class Syma
  module UiHelpers
    def go_to ui_component, &block
      world.visit ui_component.component_path

      return if block.nil?

      if block.arity == 1
        block.call(ui_component)
      elsif block.arity == -1
        ui_component.instance_eval &block
      else
        raise ArgumentError, "block takes either 1 or 0 parameters"
      end
    end
    alias :navigate_to :go_to
  end
end
