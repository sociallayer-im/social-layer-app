require "test_helper"

class Api::BadgeControllerTest < ActionDispatch::IntegrationTest

  test "api#badge/create" do
    auth_token = gen_auth_code($account_addr)
    post api_profile_create_url, params: {auth_token: auth_token, username: "coder"}
    assert_response :success
    # p response.body

    post api_badge_create_url, params: {auth_token: auth_token, issuer_id: $account_addr, name: "GoodBadge", title: "GoodBadge",  domain: "goodbadge", image_url: "http://example.com/img.jpg"}
    assert_response :success
    p response.body

    badge_id = JSON.parse(response.body)["badge"]["id"]

    post api_badge_send_url, params: {auth_token: auth_token, id: badge_id, receiver_id: $account_addr, content: "good badge"}
    assert_response :success
    p response.body

    post api_badge_accept_url, params: {auth_token: auth_token, id: badge_id}
    assert_response :success
    p response.body

    get api_badge_list_url, params: {auth_token: auth_token}
    assert_response :success
    p response.body
  end

end
