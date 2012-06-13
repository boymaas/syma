require 'sinatra_app/simple'
require 'sinatra_app/syma_config'

require 'syma/test_helpers'

require 'logger'
require 'syma/session_driver/logger'

module SinatraApp
  describe "applying syma to a rack test app" do
    before :all do
      capybara_session = Capybara::Session.new(:rack_test, SinatraApp::Simple)
      session_driver = Syma::SessionDriver::Capybara.new(capybara_session)
      logging_session_driver = Syma::SessionDriver::Logger.new(session_driver, ::Logger.new(STDOUT))
      Syma.configure do |c|
        c.ui_driver_class      UIDriver
        c.given_driver_class   GivenDriver
        c.session_driver_instance session_driver
        # c.session_driver_instance logging_session_driver
      end  
    end

    # Clear class variables
    before { Simple.clear }

    before do
      extend Syma::TestHelpers

      # Create user bob and add 2 widgets
      given.a_user(:bob)
      given.a_widget(:widget_a)
      given.a_widget(:widget_b, :name => 'Foo')

      ui.sign_in(:bob)
    end


    context "/widgets" do
      before do
        ui.view_widget_screen
      end
      context "given: no mutations" do
        it "widget list contain widget_a and widget_b" do
          ui.widget_screen.widgets_data.should == mental_model.widgets.values_at(:widget_a, :widget_b)
        end
        it "after creating a new widget, it is visible in the list" do
          ui.create_new_widget(:widget_c, :name => 'Bar')
          ui.widget_screen.widgets_data.should == mental_model.widgets.values_at(:widget_a, :widget_b, :widget_c)
        end
        it "after deleteing a widget, it should be removed from the list" do
          ui.delete_widget(:widget_b)
          ui.widget_screen.widgets_data.should == mental_model.widgets.values_at(:widget_a)
        end
        it "returns the widgets as components" do 
          widget_components = ui.widget_screen.widgets
          widget_components.map {|wc| {:id => wc.id, :name => wc.name} }.
            should == mental_model.widgets.values_at(:widget_a, :widget_b)
        end
      end

      context "given: accessing ui components which are not visible" do
        it "gives meaningfull error messages" do
          ui.navigate_to ui.sign_in_screen

          expect {
            ui.widget_screen.last_widget_created
          }.to raise_error { |error|
            error.should be_an(Syma::SessionDriver::ElementNotFound)
            error.message.should include %{error message                : [Unable to find css "#widget_list"]}
            error.message.should include %{session_driver.current_path  : [/session/new]}
            error.message.should include %{ui_component class           : [SinatraApp::WidgetScreen]}
#           error.message.should include %{calling function             : [in `last_widget_created']}
          }
        end
        it "just for displaying uncomment" do
#         ui.navigate_to ui.sign_in_screen
#         ui.widget_screen.last_widget_created
        end
      end
    end
  end

end

