require 'syma/ui_driver'

class Syma
  describe UIDriver do
    context "#initialize" do
      it "takes a configuration" do
        configuration = stub(:configuration)
        described_class.new(configuration)
      end
    end

    context ".ui_component" do
      it "is present, tested at module" do
        TmpClass = Class.new(UIDriver) do
          ui_component :label, :Class 
        end
        
      end
    end

    contexy "#go_to" do
      
    end

  end
end
