require 'syma/attr_initializer'

class Syma
  describe AttrInitializer do
    before do
      Object::TestClass = Class.new do
        include AttrInitializer

        attr_initializer :component_path
        attr_initializer :component_selector
      end
    end

    after { Object.send(:remove_const, :TestClass) }

    context ".component_{path,selector}" do
      context "given: configured using scalars" do
        let (:ui_component) do
          Class.new(TestClass) do
            component_path     :a_component_path 
            component_selector :a_component_selector 
          end
        end

        subject { ui_component.new }

        specify { subject.component_path.should == :a_component_path }
        specify { subject.component_selector.should == :a_component_selector }

      end
      context "given: configured using blocks" do
        let (:ui_component) do
          Class.new(TestClass) do
            component_path     { :a_component_path }
            component_selector { :a_component_selector } 
          end
        end

        subject { ui_component.new }

        specify { subject.component_path.should == :a_component_path }
        specify { subject.component_selector.should == :a_component_selector }
      end
      context "given: configured using blocks" do
        let (:ui_component) do
          Class.new(TestClass) do
            component_path     { an_instance_method }
            component_selector { an_instance_method } 

            def an_instance_method
              :an_instance_method
            end
          end
        end

        subject { ui_component.new }

        specify { subject.component_path.should == :an_instance_method }
        specify { subject.component_selector.should == :an_instance_method }
      end
    end

  end

end
