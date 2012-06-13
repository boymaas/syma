require 'syma/ui_session_driver_forwardable'

class Syma
  describe UiSessionDriverForwardable do
    before do
      Object::ForwardableClass = Class.new do
        include UiSessionDriverForwardable
      end
    end

    after {Object.send :remove_const, :ForwardableClass }

    subject {ForwardableClass.new}

    context "method session_driver forwarding" do
      let(:session_driver) { stub(:session_driver) }
      before do
        subject.stub(:component_selector => :component_selector)
        subject.stub(:session_driver => session_driver)
      end
      before do
        session_driver.stub(:respond_to? => true)
        session_driver.stub(:existing_method  => :yihaa)
        def session_driver.within comp_sel
          yield
        end
      end
      context "autoforwarding" do
        it "is automatically forwarded" do
          session_driver.should_receive(:existing_method)
          subject.existing_method
        end
      end
      context "#in_session_driver" do
        context "without parameter" do
          it "is forwarded inside in_session_driver" do
            session_driver.should_receive(:existing_method)
            subject.in_session_driver do
              existing_method
            end
          end
        end
        context "with parameter" do
          it "is forwarded inside in_session_driver" do
            session_driver.should_receive(:existing_method)
            subject.in_session_driver do |w|
              w.existing_method
            end
          end
          it "is not forwarded inside in_session_driver" do
            expect {
              subject.in_session_driver do |w|
              existing_method
              end
            }.to raise_error(NameError)
          end
        end
      end
    end
  end
end
