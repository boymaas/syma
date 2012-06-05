class Syma
  module TestHelpers
    def syma
      @syma ||= Syma.new
    end

    def ui
      syma.ui_driver
    end

    def given
      syma.given_driver
    end
  end
end

