module AttrAccessorF
  def attr_accessor_f accessor_name
    class_eval <<-EOF, __FILE__, __LINE__ + 1
      def #{accessor_name} v=:no_#{accessor_name}_defined
        unless v==:no_#{accessor_name}_defined
          @#{accessor_name} = v
        end
        @#{accessor_name}
      end
    EOF
  end
end
