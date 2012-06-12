require 'syma/basic_object'

class Syma
  module UiSessionDriverForwardable
    def session_driver
      configuration.session_driver_instance
    end

    def in_session_driver &block
      if block.arity == 1
        block.call(session_driver)
      else
        session_driver.instance_eval(&block) 
      end
    end

    def in_scoped_session_driver &block
      session_driver.within(component_selector) do
        in_session_driver(&block)
      end
    end

    def method_missing(m,*a,&block)
      if session_driver.respond_to?(m)
        session_driver.within(component_selector) do
          return session_driver.send(m, *a, &block)
        end
      end
      super
    end
  end

end
