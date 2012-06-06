require 'syma/basic_object'

class Syma
  module UiWorldForwardable
    def world
      configuration.world
    end

    def in_world &block
      if block.arity == 1
        block.call(world)
      else
        world.instance_eval(&block) 
      end
    end

    def in_world_within &block
      world.within(component_selector) do
        in_world(&block)
      end
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
