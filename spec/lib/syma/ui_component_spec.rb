require 'syma/ui_component'

class Syma
  describe UIComponent do
    let(:world) { stub(:world) }
    let(:config) { stub(:config, :world => world) }

    subject { described_class.new(config) }
     
    context "#initialize" do
      it "sets the world" do
        subject.world.should == world
        
      end
    end

    context ".ui_component" do
      it "is present, tested at module" do
        TmpClass = Class.new(UIComponent) do
          ui_component :label, :Class 
        end
        
      end
    end

    context ".component_{path,selector}" do
      context "given: configured using scalars" do
        let (:ui_component) do
          Class.new(UIComponent) do
            component_path     :a_component_path 
            component_selector :a_component_selector 
          end
        end

        subject { ui_component.new(config) }

        specify { subject.component_path.should == :a_component_path }
        specify { subject.component_selector.should == :a_component_selector }

      end
      context "given: configured using blocks" do
        let (:ui_component) do
          Class.new(UIComponent) do
            component_path     { :a_component_path }
            component_selector { :a_component_selector } 
          end
        end

        subject { ui_component.new(config) }

        specify { subject.component_path.should == :a_component_path }
        specify { subject.component_selector.should == :a_component_selector }
      end
      context "given: configured using blocks" do
        let (:ui_component) do
          Class.new(UIComponent) do
            component_path     { an_instance_method }
            component_selector { an_instance_method } 

            def an_instance_method
              :an_instance_method
            end
          end
        end

        subject { ui_component.new(config) }

        specify { subject.component_path.should == :an_instance_method }
        specify { subject.component_selector.should == :an_instance_method }
      end
    end

    context "#visible?" do
      it "delegates to world find" do
        subject.stub(:component_selector => :component_selector)
        world.should_receive(:find).with(:component_selector).
          and_return(nil)

        subject.visible?.should == false
      end

    end

    context "#method_missing" do
      before do
        subject.stub(:component_selector => :component_selector)
      end
      context "world responds to method" do
        before do
          world.stub(:respond_to? => true)
          world.stub(:existing_method  => :yihaa)
          def world.within comp_sel
            yield
          end
        end
        it "should be called" do
          world.should_receive(:existing_method)
          subject.existing_method
        end

      end
      context "world does not respond to method" do
        before do
          world.stub(:respond_to? => false)
        end
        it "should not be called" do
          world.should_not_receive(:non_existing_method)
          expect {
            subject.non_existing_method
          }.to raise_error(NoMethodError)
        end
      end
    end
  end
end
