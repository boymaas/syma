class Syma
  module SessionDriver
    class Capybara
      module Interface
        attr_reader :scope

        def each_element_matching selector, &block
          raise ArgumentError, "each element in needs a block" if block.nil?
          index = 0
          caps.all(selector).map do |el|
            if block.arity > 1
              block.call(Element.new(el), index)
              index += 1
            else
              block.call(Element.new(el))
            end
          end
        end

        def find_element selector
          Element.new(caps.find(selector))
        end

        def find_text selector
          caps.find(selector).text 
        end

        def find_form_field selector
          InputField.new(caps, selector)
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
