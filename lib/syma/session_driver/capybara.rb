require 'syma/basic_object'

class Syma
  module SessionDriver
    class CapybaraExceptionTranslator < BasicObject
      def initialize(interface)
        @interface = interface
      end

       def respond_to?(m, *a)
         @interface.respond_to?(m) || super
       end

      def method_missing(m, *a, &block)
        if @interface.respond_to?(m)
          begin
            return @interface.send(m, *a, &block)
          rescue ::Capybara::ElementNotFound => e
            raise ElementNotFound, e.message
          end
          super
        end
      end
    end

    class Capybara  < DelegateClass(CapybaraExceptionTranslator)
      require 'syma/session_driver/capybara/interface'

      def initialize(capy_session)
        @interface = Interface.new(capy_session)
        @interface = CapybaraExceptionTranslator.new(@interface)
        super(@interface)
      end

      def navigate_to path
        @interface.caps.visit(path)
      end

      class Element < Interface
        def tag_name
          caps.tag_name
        end

        def path
          caps.path
        end
      end

      class InputField < Element
        # getValue
        def get_value
          element.value
        end
        # setValue
        def set_value v
          element.set(v)
        end
      end
    end
  end
end
