require "syma/ui_driver"
require "syma/given_driver"
require "syma/ui_component"
require "syma/mental_model"
require "syma/attr_accessor_f"

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
  end

  def ui_driver
    @ui_driver ||= configuration.instantiate_ui_driver_class
  end

  def given_driver
    @given_driver ||= configuration.instantiate_given_driver_class
  end


  class Configuration
    def initialize
      mental_model MentalModel.new
    end

    extend AttrAccessorF

    attr_accessor_f :world
    attr_accessor_f :mental_model

    attr_accessor_f :ui_driver_class
    attr_accessor_f :given_driver_class

    def instantiate_ui_driver_class
      ui_driver_class.new(self)
    end

    def instantiate_given_driver_class
      given_driver_class.new(self)
    end

    def dup
      Marshal.load(Marshal.dump(self))
    end
  end


end

