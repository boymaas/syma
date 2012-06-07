require 'syma/session_driver/capybara/interface'

class Syma
  module SessionDriver
    class Capybara
      include Interface

      def initialize(capybara_session)
        @capy_session = capybara_session
      end

      def caps
        @capy_session
      end

      def navigate_to path
        caps.visit(path)
      end


      class Element
        include Interface

        def initialize(capy_session, selector)
          @capy_session = capy_session 
          @scope = selector
        end

        def caps
          @capy_session
        end
      end

      class InputField < Element
        # getValue
        def get_value
          caps.find(@selector).text
        end
        # setValue
        def set_value v
          caps.find(@selector).set(v)
        end
      end
    end
  end
end
