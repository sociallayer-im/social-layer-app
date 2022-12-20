require "test_helper"

class Api::ProfileControllerTest < ActionDispatch::IntegrationTest

  test "api#profile/home" do
    get root_url
    assert_response :success
  end

  test "api#profile/current" do
    prof = Profile.find_or_create_by(address: $account_addr, username: "coderr", domain: "coderr.sociallayer.im")
    auth_token = gen_auth_token(prof.id)
    get api_siwe_current_url, params: {auth_token: auth_token}
    assert_response :success
    p response.body

    prof = Profile.find_or_create_by(address: $account_addr, username: "coderr", domain: "coderr.sociallayer.im")
    auth_token = gen_wrong_auth_token(prof.id)
    get api_siwe_current_url, params: {auth_token: auth_token}
    p response.body

    get api_siwe_current_url
    p response.body
  end

  test "api#profile/current_account" do
    prof = Profile.find_or_create_by(address: $account_addr, username: "coderr", domain: "coderr.sociallayer.im")
    auth_token = gen_auth_token(prof.id)
    get api_siwe_current_url, params: {auth_token: auth_token}
    assert_response :success
    p response.body

    prof = Profile.find_or_create_by(address: $account_addr, username: "coderr", domain: "coderr.sociallayer.im")
    auth_token = gen_wrong_auth_token(prof.id)
    get api_siwe_current_account_url, params: {auth_token: auth_token}
    p response.body

    get api_siwe_current_account_url
    p response.body
  end

  test "api#profile/create" do
    prof = Profile.find_or_create_by(address: $account_addr)
    auth_token = gen_auth_token(prof.id)
    post api_profile_create_url, params: {auth_token: auth_token, username: "coderr"}
    assert_response :success
  end

  # test "api#profile/signin_with_email" do
  #   post api_profile_send_email_url, params: {email: "hello@email.com"}
  #   assert_response :success
  #   p response.body

  #   post api_profile_signin_with_email_url, params: {email: "hello@email.com", code: MailToken.last.code}
  #   assert_response :success
  #   p response.body
  #   auth_token = JSON.parse(response.body)["auth_token"]
  # end

  test "api#profile/get" do
    prof = Profile.find_or_create_by(address: $account_addr)
    auth_token = gen_auth_token(prof.id)

    post api_profile_create_url, params: {auth_token: auth_token, username: "coderr"}
    assert_response :success
    p response.body

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
