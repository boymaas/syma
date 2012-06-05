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

    context "method world forwarding" do
      before do
        subject.stub(:component_selector => :component_selector)
      end
      before do
        world.stub(:respond_to? => true)
        world.stub(:existing_method  => :yihaa)
        def world.within comp_sel
          yield
        end
      end
      context "autoforwarding" do

        it "is not automatically forwarded" do
          expect {
            subject.existing_method
          }.to raise_error(NoMethodError)
        end
      end
      context "#in_world" do
        context "without parameter" do
          it "is forwarded inside in_world" do
            world.should_receive(:existing_method)
            subject.in_world do
              existing_method
            end
          end
        end
        context "with parameter" do
          it "is forwarded inside in_world" do
            world.should_receive(:existing_method)
            subject.in_world do |w|
              w.existing_method
            end
          end
          it "is not forwarded inside in_world" do
            expect {
              subject.in_world do |w|
              existing_method
              end
            }.to raise_error(NameError)
          end
        end
      end
    end
  end
end
