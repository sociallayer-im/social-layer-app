require "test_helper"

class Api::BadgeControllerTest < ActionDispatch::IntegrationTest

  test "api#presend/create" do
    prof = Profile.find_or_create_by(address: $account_addr, username: "giverr", domain: "giverr.sociallayer.im")
    auth_token = gen_auth_token(prof.id)

    prof2 = Profile.find_or_create_by(address: $account_addr2, username: "takerr", domain: "takerr.sociallayer.im")
    auth_token2 = gen_auth_token(prof2.id)

    post api_badge_create_url, params: {auth_token: auth_token, name: "GoodBadge", title: "GoodBadge",  domain: "goodbadge", image_url: "http://example.com/img.jpg"}
    assert_response :success
    p response.body

    badge_id = JSON.parse(response.body)["badge"]["id"]

    post api_presend_create_url, params: {auth_token: auth_token, badge_id: badge_id, message: "welcome", counter: 10}
    assert_response :success
    p response.body

    presend = Presend.last
    post api_presend_use_url, params: {auth_token: auth_token2, id: presend.id, code: presend.code}
    assert_response :success
    p response.body

    get api_presend_get_url, params: {auth_token: auth_token, id: presend.id}
    assert_response :success
    p JSON.parse(response.body)["presend"]

    presend = Presend.last
    post api_presend_revoke_url, params: {auth_token: auth_token, id: presend.id}
    assert_response :success
    p response.body

    get api_presend_list_url, params: {auth_token: auth_token}
    assert_response :success
    p JSON.parse(response.body)["presends"]

    puts 'sender'
    get api_presend_list_url, params: {auth_token: auth_token, sender_id: prof.id}
    assert_response :success
    p JSON.parse(response.body)["presends"]

    get api_presend_list_url, params: {auth_token: auth_token, sender_id: prof2.id}
    assert_response :success
    p JSON.parse(response.body)["presends"]

    get api_presend_list_url, params: {sender_id: prof.id}
    assert_response :success
    p JSON.parse(response.body)["presends"]

  end

end
