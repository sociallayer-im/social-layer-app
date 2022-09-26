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
    post api_profile_create_url, params: {auth_token: auth_token, username: "coderr"}
    assert_response :success
    # p response.body
  end

  test "api#profile/email_signin" do
    post api_profile_email_signin_url, params: {email: "hello@email.com"}
    assert_response :success
    p response.body

    post api_profile_email_signin_verify_url, params: {email: "hello@email.com", code: MailToken.last.code}
    assert_response :success
    p response.body
  end

  test "api#profile/get" do
    auth_token = gen_auth_code($account_addr)
    post api_profile_create_url, params: {auth_token: auth_token, username: "coderr"}

    get api_profile_get_url, params: {address: $account_addr}
    assert_response :success
    p response.body

    get api_profile_get_url, params: {username: "coderr"}
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
