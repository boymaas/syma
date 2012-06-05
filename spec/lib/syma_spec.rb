require 'lib/syma'

describe Syma do
  context "class methods and configuration" do
    before do
      described_class.configure do |c|
        c.ui_driver_class :UIDriver 
        c.given_driver_class :GivenDriver 
        c.world :World
      end
    end
    context "#initialize" do
      it "on initialization it has the class instance configuration" do
        subject.configuration.ui_driver_class == :UIDriver
        subject.configuration.ui_driver_class == :GivenDriver
        subject.configuration.world == :World
      end
    end

    context ".configuration" do
      it "has a configuration" do
        described_class.configuration.should be_an(Syma::Configuration)
      end
    end

    context ".configure" do
      it "can be configured" do
        described_class.configuration.ui_driver_class.should == :UIDriver
        described_class.configuration.given_driver_class.should == :GivenDriver
        described_class.configuration.world.should == :World
      end
    end
  end

  context "#given_driver" do
    let(:config) { stub(:config) }

    it "memoizes the given_driver_class as specified in the configuration" do
      subject = described_class.new(config) 
      config.should_receive(:instantiate_given_driver_class).
        and_return(:given_driver_instance)

      subject.given_driver.should == :given_driver_instance
    end
  end

  context "#ui_driver" do
    let(:config) { stub(:config) }

    it "memoizes the given_driver_class as specified in the configuration" do
      subject = described_class.new(config) 
      config.should_receive(:instantiate_ui_driver_class).
        and_return(:ui_driver_instance)

      subject.ui_driver.should == :ui_driver_instance
    end

  end

end
