require 'delegate'
require 'syma/exceptions'

class Syma
  class MentalModel
    def initialize
      @data = {}
    end

    def method_missing(name, *args)
      return super unless args.empty?
      @data[name] ||= Collection.new(name)
    end

    def respond_to?
      true
    end

    class Collection 
      attr_reader :data

      def initialize(name, init_data = nil)
        @name = name
        @data = Hash.new do |hash, key|
          raise UnknownKeyError, "Can't find mental_model.#{@name}[#{key.inspect}]. Did you forget to set it?"
        end
        data.merge!(init_data) unless init_data.nil?
        super(data)
      end

      def [](k)
        data[k]
      end

      def []=(k,v)
        data[k] = v
      end
      
      def keys
        data.keys
      end

      def values_at(*a)
        a.map {|k| data[k]} 
      end

      def ===(other)
        self.object_id == other.object_id
      end

      def slice(*keys)
        data = keys.inject({}) { |memo, key|
          memo[key] = self[key]
          memo
        }
      end

      def except(*keys)
        slice(*(self.keys - keys))
      end

      def delete(key, &block)
        self[key] # simple fetch to possibly trigger UnknownKeyError
        deleted[key] = data.delete(key, &block)
      end

      def deleted
        @deleted ||= self.class.new("deleted")
      end

      def delete_if(&block)
        move = lambda { |k,v| deleted[k] = v; true }
        data.delete_if { |k,v| block.call(k,v) && move.call(k,v) }
      end

      def dup
        new_data = {}.merge(self.data)
        new_data = Marshal.load(Marshal.dump(new_data))
        self.class.new(@name, new_data)
      end
    end
  end
end
