require 'syma'
require 'syma/test_helpers'

RSpec.configure do |c|
  c.include( Syma::TestHelpers, :type => :request )
  c.before do
    Syma.configure do |s|
      s.session_driver_instance( self )
    end
  end
end

