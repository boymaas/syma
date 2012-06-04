class Syma
  class UIDriver
    def initialize(configuration)
      @configuration = configuration 
    end

    class << self
      def ui_component label, component_class
        define_method(label) do
          component_class.new(@configuration)
        end
      end
    end
  end
end
