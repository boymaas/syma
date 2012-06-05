require 'syma/basic_object'

class Syma
  module UiWorldForwardable
    def world
      configuration.world
    end

    def limited_world
      @limited_world ||= LimitedWorld.new(world, self.component_selector)
    end

    alias :w :limited_world

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
  end

  class LimitedWorld < BasicObject
    def initialize(world, selector)
      @world = world 
      @selector = selector
    end
    def method_missing(m, *a)
      @world.within(@selector) do
        @world.send(m, *a)
      end
    end
  end
end
