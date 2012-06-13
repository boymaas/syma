class Syma
  module UiHelpers
    def go_to ui_component, &block
      session_driver.navigate_to ui_component.component_path

      return if block.nil?

      if block.arity == 1
        block.call(ui_component)
      elsif block.arity <= 0 # ruby 1.9 gives 0 and 1.8.7 gives -1 on 0 params
        ui_component.instance_eval &block
      else
        raise ArgumentError, "block takes either 1 or 0 parameters"
      end
    end
    alias :navigate_to :go_to
  end
end
