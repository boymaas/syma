require 'syma/ui_component_factory_method'
require 'syma/attr_initializer'


class Syma
  class UIComponent 
    attr_reader :world, :configuration

    include UiComponentFactoryMethod
    include AttrInitializer

    attr_initializer :component_path
    attr_initializer :component_selector

    def initialize(configuration)
      @configuration = configuration
      @world = @configuration.world
    end


    def visible?
      !!world.find(component_selector)
    end

    # Delegate all missing methods to
    # world in a capybara within selector
    def method_missing(m,*a)
      if world.respond_to?(m)
        world.within(component_selector) do
          return world.send(m, *a)
        end
      end
      super
    end
  end
end
