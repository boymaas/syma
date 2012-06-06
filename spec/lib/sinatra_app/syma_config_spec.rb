require 'sinatra_app/simple'
require 'sinatra_app/syma_config'

require 'syma/test_helpers'

module SinatraApp
  describe "applying syma to a rack test app" do
    before :all do
      Syma.configure do |c|
        c.ui_driver_class    UIDriver
        c.given_driver_class GivenDriver
        c.world              Capybara::Session.new(:rack_test, SinatraApp::Simple)
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
    end
  end

end

