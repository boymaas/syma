require 'syma/ui_component_factory_method'

class Syma
  class UIDriver
    attr_reader :configuration

    include UiComponentFactoryMethod

    def initialize(configuration)
      @configuration = configuration 
    end

    def go_to ui_component
      configuration.world.visit ui_component.component_path
    end
  end
end
