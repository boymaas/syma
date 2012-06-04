require "syma/ui_driver"
require "syma/ui_component"
require "syma/mental_model"

class Syma
  # Minimal configuration
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure &block
      block.call(configuration)
    end
  end

  attr_reader :configuration

  def initialize(configuration = self.class.configuration)
    @configuration = configuration
    @configuration.mental_model MentalModel.new
  end

  def ui_driver
    @ui_driver ||= configuration.ui_driver_class.new(configuration)
  end

  class Configuration

    def ui_driver_class driver_class=:no_driver_class
      unless driver_class == :no_driver_class
        @ui_driver_class = driver_class
      end
      @ui_driver_class
    end

    def world world=:no_world
      unless world == :no_world
        @world = world
      end
      @world
    end

    def mental_model model=:no_model
      unless model == :no_model
        @model = model
      end
      @model
    end

    def dup
      Marshal.load(Marshal.dump(self))
    end
  end

end

