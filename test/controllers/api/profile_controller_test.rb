require "test_helper"
require 'jwt'

$hmac_secret = Rails.application.secret_key_base
$account_addr = "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"

class Api::ProfileControllerTest < ActionDispatch::IntegrationTest
  def gen_auth_code(addr)
    payload = {address: addr}
    $hmac_secret = Rails.application.secret_key_base
    JWT.encode payload, $hmac_secret, 'HS256'
  end

  test "api#profile/home" do
    get root_url
    assert_response :success
  end

  test "api#profile/current" do
    auth_token = gen_auth_code($account_addr)
    get api_siwe_current_url, params: {auth_token: auth_token}
    assert_response :success
    # p response.body
  end

  test "api#profile/create" do
    auth_token = gen_auth_code($account_addr)
    post api_profile_create_url, params: {auth_token: auth_token, username: "coder"}
    assert_response :success
    # p response.body
  end

  test "api#profile/get" do
    auth_token = gen_auth_code($account_addr)
    post api_profile_create_url, params: {auth_token: auth_token, username: "coder"}

    get api_profile_get_url, params: {address: $account_addr}
    assert_response :success
    p response.body

    get api_profile_get_url, params: {username: "coder"}
    assert_response :success
    p response.body
  end
end
