class Syma
  class UIComponent 
    attr_reader :world

    def initialize(config)
      @config = config
      @world = config.world
    end

    # overload this to specify component path
    def component_path
      raise "component_path should be specified for #{self.class}"
    end

    def component_selector
      raise "component_selector should be specified for #{self.class}"
    end

    def visible?
      !!@world.find(component_selector)
    end

    # Delegate all missing methods to
    # world in a capybara within selector
    def method_missing(m,*a)
      if @world.respond_to?(m)
        @world.within(component_selector) do
          return @world.send(m, *a)
        end
      end
      super
    end
  end
end
