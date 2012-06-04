class Syma
  module UiComponentFactoryMethod
    def self.included base
      base.extend ClassMethods
    end

    module ClassMethods
      def ui_component label, component_class
        define_method(label) do
          component_class.new(@configuration)
        end
      end
    end
  end
end
