require 'syma/ui_component_factory_method'
require 'syma/ui_world_forwardable'
require 'syma/ui_helpers'
require 'syma/attr_initializer'

class Syma
  class UIComponent 
    attr_reader :configuration

    include UiComponentFactoryMethod
    include UiHelpers
    include UiWorldForwardable
    include AttrInitializer

    attr_initializer :component_path
    attr_initializer :component_selector

    def initialize(configuration)
      @configuration = configuration
    end

    def mental_model
      configuration.mental_model
    end

    def visible?
      !!world.find(component_selector)
    end

  end
end

class Syma
  class UIComponent
    class << self
      def load_and_module_eval_relative glob
        dirname = File.dirname(caller[0])
        Dir["#{dirname}/#{glob}"].each do |ui_component|
          module_eval File.read(ui_component), ui_component, 1
        end
      end
    end
  end
end

