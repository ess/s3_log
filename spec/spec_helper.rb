require 'rspec'
require 'rspec/mocks'
require 'rspec/expectations'

$:.unshift File.join(File.dirname(__FILE__), '..')

RSpec.configure do |config|
  config.mock_framework = :rspec
end
