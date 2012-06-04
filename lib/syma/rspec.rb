require 'syma'
require 'syma/test_helpers'

RSpec.configure do |c|
  c.include( Syma::TestHelpers, :type => :request )
  c.before do
    Syma.configure do |s|
      s.world( self )
    end
  end
end

