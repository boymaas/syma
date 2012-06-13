class Syma
  module SessionDriver
    class RuntimeError < ::RuntimeError; end
    class ElementNotFound < RuntimeError; end
  end
end
