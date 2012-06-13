require 'syma/ui_component_factory_method'
require 'syma/ui_session_driver_forwardable'
require 'syma/ui_helpers'
require 'syma/attr_initializer'

class Syma
  class UIComponent 
    attr_reader :configuration

    include UiComponentFactoryMethod
    include UiHelpers
    include UiSessionDriverForwardable
    include AttrInitializer

    attr_initializer :component_path
    attr_initializer :component_selector

    class << self
      def def_text_field name, options={}
        selector = options.fetch(:selector, name.to_s)

        class_eval <<-EOF, __FILE__, __LINE__ + 1
          def #{name} v=nil
            unless v.nil?
              find_form_field('#{selector}').set_value(v)
            end
            find_form_field('#{selector}').get_value
          end
        EOF
      end
      alias :def_password_field :def_text_field
      alias :def_textarea :def_text_field

      def def_submitter name, options={}
        selector = options.fetch(:selector, name.to_s)

        define_method name do
          click_on(selector)  
        end
      end

      def def_text_lookup name, options={}
        selector = options.fetch(:selector, name.to_s)
        strip = options.fetch(:strip, false)

        define_method name do
          v = find_text(selector)
          strip ? v.strip : v
        end
      end
    end

    def initialize(configuration)
      @configuration = configuration
    end

    def mental_model
      configuration.mental_model
    end


    def visible?
      !!session_driver.find_element(component_selector)
    end

  end
end

class Syma
  class UIComponent
    class << self
      def load_and_module_eval_relative glob
        dirname = File.dirname(caller[0])
        Dir["#{dirname}/#{glob}"].each do |ui_component|
          module_eval File.read(ui_component), ui_component, 1
        end
      end
    end
  end
end

