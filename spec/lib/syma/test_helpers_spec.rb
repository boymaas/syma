require 'syma'
require 'syma/test_helpers'

class Syma
  describe TestHelpers do
    before do
      Syma.configure do |c|
        c.ui_driver_class UIDriver 
      end
    end
    let(:enclosing_class) do
      Class.new do
        extend TestHelpers
      end
    end

    context "#syma" do
      it "returns a memoized Syma object" do
        enclosing_class.syma.should be_an(Syma)
        enclosing_class.syma.object_id == enclosing_class.syma.object_id
      end
    end

    context "#ui" do
      it "returns a memoized ui_driver" do
        enclosing_class.ui.should be_an(UIDriver)
        enclosing_class.ui.object_id == enclosing_class.ui.object_id
      end
    end

  end
end
