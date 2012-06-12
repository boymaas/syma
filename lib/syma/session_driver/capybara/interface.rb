class Syma
  module SessionDriver
    class Capybara
      module Interface
        attr_reader :scope

        def find_element selector
          caps.find(selector) 
        end

        def find_text selector
          caps.find(selector).text 
        end

        def find_form_field selector
          InputField.new(caps, selector)
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
