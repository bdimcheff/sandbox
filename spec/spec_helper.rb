require 'rubygems'
require 'spec'

$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'sandbox'

Spec::Runner.configure do |config|
  config.mock_with :flexmock
end
