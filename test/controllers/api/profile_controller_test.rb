require "test_helper"

class Api::ProfileControllerTest < ActionDispatch::IntegrationTest

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

    get api_profile_list_url
    assert_response :success
    p response.body

    get api_profile_search_url, params: {username: "cod"}
    assert_response :success
    p response.body
  end
end
