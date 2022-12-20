ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

require 'jwt'

$hmac_secret = Rails.application.secret_key_base
$account_addr = "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"
$account_addr2 = "0x70997970c51812dc3a010c7d01b50e0d17dc79c8"

def gen_auth_code(addr)
  payload = {address: addr}
  $hmac_secret = Rails.application.secret_key_base
  JWT.encode payload, $hmac_secret, 'HS256'
end

def gen_auth_token(id)
  payload = {id: id}
  $hmac_secret = Rails.application.secret_key_base
  JWT.encode payload, $hmac_secret, 'HS256'
end

def gen_wrong_auth_token(id)
  payload = {id: id}
  $hmac_secret = Rails.application.secret_key_base
  JWT.encode payload, "$hmac_secret", 'HS256'
end

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
