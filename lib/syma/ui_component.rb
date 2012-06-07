require 'syma/ui_component_factory_method'
require 'syma/ui_world_forwardable'
require 'syma/ui_helpers'
require 'syma/attr_initializer'

class Syma
  class UIComponent 
    attr_reader :configuration

    include UiComponentFactoryMethod
    include UiHelpers
    include UiWorldForwardable
    include AttrInitializer

    attr_initializer :component_path
    attr_initializer :component_selector

    class << self
      def def_text_field_accessor name, options={}
        selector = options.fetch(:selector, name.to_s)

        class_eval <<-EOF
          def #{name} v=nil
            unless v.nil?
              find('#{selector}').set(v)
            end
            find('#{selector}').text
          end
        EOF
      end
      alias :def_password_field_accessor :def_text_field_accessor
      alias :def_textarea_accessor :def_text_field_accessor

      def def_submitter name, options={}
        selector = options.fetch(:selector, name.to_s)

        class_eval <<-EOF
          def #{name} v=nil
            click_button('#{selector}')
          end
        EOF
      end

      def def_text_lookup_reader name, options={}
        selector = options.fetch(:selector, name.to_s)
        strip = options.fetch(:strip, false)

        class_eval <<-EOF
          def #{name}
            v = find('#{selector}').text
            #{strip ? 'v.strip' : 'v'}
          end
        EOF
      end
    end

    def initialize(configuration)
      @configuration = configuration
    end

    def mental_model
      configuration.mental_model
    end

    def visible?
      !!world.find(component_selector)
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

