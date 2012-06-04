require 'syma/ui_component_factory_method'

class Syma
  class UIComponent 
    attr_reader :world, :configuration, :component_path, :component_selector

    include UiComponentFactoryMethod

    class << self
      def component_path(path=nil, &block)
        path     && @component_path = path
        block    && @component_path = block
        @component_path
      end

      def component_selector(selector=nil, &block)
        selector && @component_selector = selector
        block    && @component_selector = block
        @component_selector
      end
    end

    def component_path
      @component_path ||=  
        begin
          v = self.class.component_path
          v.is_a?(Proc) ? instance_eval(&v) : v
        end
    end

    def component_selector
      @component_selector ||=
        begin
          v = self.class.component_selector
          v.is_a?(Proc) ? instance_eval(&v) : v
        end
    end

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
