require 'syma/ui_component_factory_method'

class Syma
  describe UiComponentFactoryMethod do
    context ".ui_component" do
      before do
        TmpClass = Class.new do
          include UiComponentFactoryMethod        
        end
      end
      context "component factory method" do
        it "returns the ui_component_class" do
          ui_component_class =  mock(Class) 

          ui_component_class.should_receive(:new).
            and_return(:a_configured_ui_component_instance)

          ui_driver_class = Class.new(TmpClass) do 
            ui_component :ui_component_factory_method, ui_component_class
          end

          ui_driver = ui_driver_class.new

          ui_driver.ui_component_factory_method.
            should == :a_configured_ui_component_instance 
        end
      end
    end
  end
end
