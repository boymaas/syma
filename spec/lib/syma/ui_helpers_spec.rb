require 'syma/ui_helpers'

class Syma
  describe UiHelpers do
    let(:world) {stub(:world)}
    before do
      ClassWithUiHelpers = Class.new do
        include UiHelpers

        attr_reader :world

        def initialize world
          @world = world
        end
      end
    end

    after { Syma.send(:remove_const, :ClassWithUiHelpers) }

    subject {ClassWithUiHelpers.new(world)}

    context "#go_to" do
      let(:ui_component) { stub(:ui_component) }
      before do
        world.should_receive(:visit)
        ui_component.should_receive(:component_path)
      end
      it "takes a navigates to the component_path" do
        subject.go_to ui_component
      end
      context "given: block with 0 arguments" do
        it "calls functions on the ui_component" do
          ui_component.should_receive(:existing_function)
          subject.go_to(ui_component) { existing_function }
        end
      end
      context "given: block with 1 arguments" do
        it "calls functions on the ui_component" do
          ui_component.should_receive(:existing_function)
          subject.go_to(ui_component) { |uic| uic.existing_function }
        end
      end
    end
  end
end
