require 'syma/driver'
require 'syma/ui_component_factory_method'
require 'syma/ui_helpers'
require 'syma/ui_world_forwardable'

class Syma
  class UIDriver < Driver
    include UiComponentFactoryMethod
    include UiHelpers
    include UiWorldForwardable
  end
end
