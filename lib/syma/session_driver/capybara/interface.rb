require 'syma/session_driver/exceptions'

class Syma
  module SessionDriver
    class Capybara
      class Interface
        def initialize(capy_session)
          @capy_session = capy_session
        end

        def caps
          @capy_session
        end
        alias :element :caps

        def current_path
          caps.current_path
        end

        def each_element_matching selector, &block
          raise ArgumentError, "each element in needs a block" if block.nil?
          caps.find(selector) # just to raise an error
          index = 0
          ret = []
          caps.all(selector).map do |el|
            if block.arity > 1
              ret << block.call(Element.new(el), index)
              index += 1
            else
              ret << block.call(Element.new(el))
            end
          end
          ret
        end

        def find_element selector
          Element.new(caps.find(selector))
        end

        def find_text selector
          caps.find(selector).text 
        end

        def find_form_field selector
          InputField.new(caps.find(selector))
        end

        def fill_form_field selector, value
          find_form_field(selector).set_value(value)
        end

        def click_on selector
          caps.find(selector).click
        end
        alias :click_button :click_on

        def within(selector, &block) 
          caps.within(selector, &block)
        end
      end
    end
  end
end
