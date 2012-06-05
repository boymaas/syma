require 'syma/driver'

class Syma
  describe Driver do
    context "#initialize" do
      let(:conf) { stub(:conf) }
      subject { described_class.new(conf) }

      it "takes a configuration"  do
        subject.configuration.should == conf
        
      end
    end

  end
end
