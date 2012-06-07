class Syma
  module SessionDriver
    class Capybara
      module Interface
        attr_reader :scope

        def find_element selector
          maybe_limit_scope { caps.find(selector) }
        end

        def find_text selector
          maybe_limit_scope { caps.find(selector).text }
        end

        def find_form_field selector
          InputField.new(caps, selector)
        end

        def click_on selector
          maybe_limit_scope { caps.find(selector).click }
        end
        alias :click_button :click_on

        def within(selector, &block) 
          caps.within(selector, &block)
        end

        def maybe_limit_scope &block
          scope ? caps.within(scope, &block) : block.call
        end
      end
    end
  end
end
