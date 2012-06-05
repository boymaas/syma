require 'syma/given_driver'

class Syma
  describe GivenDriver do
    context "#initialize" do
      it "takes a configuration" do
        configuration = stub(:configuration)
        described_class.new(configuration)
      end
    end

  end
end
