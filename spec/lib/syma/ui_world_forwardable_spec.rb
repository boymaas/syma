require 'syma/ui_world_forwardable'

class Syma
  describe UiWorldForwardable do
    before do
      UiWorldForwardableClass = Class.new do
        include UiWorldForwardable
      end
    end

    subject {UiWorldForwardableClass.new}

    context "method world forwarding" do
      let(:world) { stub(:world) }
      before do
        subject.stub(:component_selector => :component_selector)
        subject.stub(:world => world)
      end
      before do
        world.stub(:respond_to? => true)
        world.stub(:existing_method  => :yihaa)
        def world.within comp_sel
          yield
        end
      end
      context "autoforwarding" do
        it "is automatically forwarded" do
          world.should_receive(:existing_method)
          subject.existing_method
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
