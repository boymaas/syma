require 'syma/driver'
require 'syma/ui_component_factory_method'
require 'syma/ui_helpers'
require 'syma/ui_session_driver_forwardable'

class Syma
  class UIDriver < Driver
    include UiComponentFactoryMethod
    include UiHelpers
    include UiSessionDriverForwardable
  end
end
