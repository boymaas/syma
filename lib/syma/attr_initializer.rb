class Syma
  module AttrInitializer
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def attr_initializer attribute_name
        class_eval <<-EOS
        class << self
          def #{attribute_name}(v=nil, &block)
            @#{attribute_name} = v || block || @#{attribute_name}
          end
        end

        def #{attribute_name}
          @#{attribute_name} ||=  
            begin
              v = self.class.#{attribute_name}
              v.is_a?(Proc) ? instance_eval(&v) : v
            end
        end
        EOS
      end
    end
  end
end
