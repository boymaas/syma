class Syma
  module UiHelpers
    def go_to ui_component
      world.visit ui_component.component_path
    end
    alias :navigate_to :go_to
  end
end
