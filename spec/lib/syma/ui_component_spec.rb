require 'syma/ui_component'

class Syma
  describe UIComponent do
    let(:session_driver) { stub(:session_driver) }
    let(:config) { stub(:config, :session_driver_instance => session_driver) }

    subject { described_class.new(config) }


    context "#initialize" do
      it "sets the session_driver_instance" do
        subject.session_driver.should == session_driver

      end
    end

    context ".ui_component" do
      it "is present, tested at module" do
        Object::TmpClass = Class.new(UIComponent) do
          ui_component :label, :Class 
        end
      end
      after { Object.send(:remove_const, :TmpClass) }
    end

    context "#visible?" do
      it "delegates to session driver" do
        subject.stub(:component_selector => :component_selector)
        session_driver.should_receive(:find_element).with(:component_selector).
          and_return(nil)

        subject.visible?.should == false
      end

    end

  end
end
