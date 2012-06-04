require 'lib/syma'

describe Syma do
  before do
    described_class.configure do |c|
      c.ui_driver_class :AClass 
      c.world :AWorld
    end
  end
  context "#initialize" do
    it "on initialization it has the class instance configuration" do
      subject.configuration.ui_driver_class == :AClass
      subject.configuration.world == :AWorld
    end
  end

  context "#configuration" do
    it "has a configuration" do
      described_class.configuration.should be_an(Syma::Configuration)
    end
  end

  context "#configure" do
    it "can be configured" do
      described_class.configuration.ui_driver_class.should == :AClass
      described_class.configuration.world.should == :AWorld
    end
  end
end
