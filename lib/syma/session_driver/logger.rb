require 'lib/syma/basic_object'

class Syma
  module SessionDriver 
    class Logger < BasicObject
      def initialize(driver, logger)
        @driver = driver
        @logger = logger
        @blacklist = [:respond_to?]
      end

      def method_missing(m, *a, &block)
         @blacklist.include?(m)
        if @driver.respond_to?(m) 
          unless @blacklist.include?(m)
            @logger.info("[#{@driver.class}].#{m}(#{a.map(&:inspect) * ','})")
          end
          return @driver.send(m, *a, &block)
        end
        super
      end
    end
  end
end
