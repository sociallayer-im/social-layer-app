require "test_helper"

class Api::GroupControllerTest < ActionDispatch::IntegrationTest
  test "api#profile/home" do
    get root_url
    assert_response :success

    prof = Profile.find_or_create_by(address: $account_addr, username: "coderr", domain: "coderr.sociallayer.im")
    auth_token = gen_auth_token(prof.id)

    prof2 = Profile.find_or_create_by(address: $account_addr2, username: "moverr", domain: "moverr.sociallayer.im")
    auth_token2 = gen_auth_token(prof2.id)

    post api_group_create_url, params: {auth_token: auth_token, username: "nicedao", about: "nice commune", image_url: "http://example.com/img.jpg"}
    assert_response :success
    p response.body

    group_id = JSON.parse(response.body)["group"]["id"]

    post api_group_update_url, params: {auth_token: auth_token, id: group_id, username: "nicedao", about: "nice community"}
    assert_response :success
    p response.body

    get api_group_list_url
    assert_response :success
    p response.body

    get api_group_get_url, params: {id: group_id}
    assert_response :success
    p response.body

    post api_group_add_member_url, params: {auth_token: auth_token, group_id: group_id}
    assert_response :success
    p response.body

    get api_group_members_url, params: {group_id: group_id}
    assert_response :success
    p response.body

    post api_group_remove_member_url, params: {auth_token: auth_token, group_id: group_id}
    assert_response :success
    p response.body

    get api_group_group_invites_url, params: {group_id: group_id}
    assert_response :success
    p response.body

    post api_group_send_invite_url, params: {auth_token: auth_token, group_id: group_id, receivers: ['moverr.sociallayer.im'], message: 'welcome'}
    assert_response :success
    p response.body
    group_invite_id = JSON.parse(response.body)["group_invites"][0]["id"]

    post api_group_accept_invite_url, params: {auth_token: auth_token2, group_invite_id: group_invite_id}
    assert_response :success
    p response.body

    get api_group_group_invites_url, params: {group_id: group_id}
    assert_response :success
    p response.body

  end
end
