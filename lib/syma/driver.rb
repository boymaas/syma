class Syma
  class Driver
    attr_reader :configuration

    def initialize(configuration)
      @configuration = configuration 
    end

    def mental_model
      configuration.mental_model
    end
  end
end
