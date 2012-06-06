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

    context "#visible?" do
      it "delegates to world find" do
        subject.stub(:component_selector => :component_selector)
        world.should_receive(:find).with(:component_selector).
          and_return(nil)

        subject.visible?.should == false
      end

    end

  end
end
