require 'syma/ui_driver'

class Syma
  describe UIDriver do
    context "#initialize" do
      it "takes a configuration" do
        configuration = stub(:configuration)
        described_class.new(configuration)
      end
    end

    context ".ui_component" do
      context "component factory method" do
        it "returns the ui_component_class" do
          ui_component_class =  mock(Class) 

          ui_component_class.should_receive(:new).
            with(:configuration).
            and_return(:a_configured_ui_component_instance)

          ui_driver_class = Class.new(UIDriver) do 
            ui_component :ui_component_factory_method, ui_component_class
          end

          ui_driver = ui_driver_class.new(:configuration)

          ui_driver.ui_component_factory_method.
            should == :a_configured_ui_component_instance 
        end
      end
    end
  end
end
