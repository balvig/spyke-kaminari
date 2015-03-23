require 'spyke'
require 'spyke/kaminari'

require 'webmock'
require 'support/test_client'
require 'support/test_service'

WebMock.disable_net_connect!

RSpec.configure do |config|
  config.include(TestService::Helpers)

  config.before(:each) { reset_service! }
end
