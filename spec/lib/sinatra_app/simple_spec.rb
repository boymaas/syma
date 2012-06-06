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
    it "returns true" do
      extend Syma::TestHelpers

      given.a_user(:bob)
      given.a_widget(:widget_a)
      given.a_widget(:widget_b, :name => 'Foo')

      ui.sign_in(:bob)


      ui.view_widget_list
      ui.widget_list.widgets.should == mental_model.widgets.values_at(:widget_a, :widget_b)

      ui.create_new_widget(:widget_c, :name => 'Bar')
      ui.widget_list.widgets.should == mental_model.widgets.values_at(:widget_a, :widget_b, :widget_c)

      ui.delete_widget(:widget_b)
      ui.widget_list.widgets.should == mental_model.widgets.values_at(:widget_a, :widget_c)
    end
  end

end
