require "test_helper"

class Api::EventControllerTest < ActionDispatch::IntegrationTest
  test "api#event/list" do
    prof = Profile.find_or_create_by(address: $account_addr, username: "coderr", domain: "coderr.sociallayer.im")
    auth_token = gen_auth_token(prof.id)

    post api_event_create_url, params: {auth_token: auth_token, title: "christmas", start_time: DateTime.current.to_s, ending_time: (DateTime.current+ 1).to_s, location_type: "online", location: "http://zoom.us", content: "wonderful", cover: "", max_participant: 10, need_approval: false, host_info: "coderr@example.com"}
    assert_response :success
    p response.body

    get api_event_list_url
    assert_response :success
    p response.body

    get api_event_get_url, params: {id: Event.last.id}
    assert_response :success
    p response.body

    post api_event_join_url, params: {auth_token: auth_token, id: Event.last.id, message: "hey"}
    assert_response :success
    p response.body

    post api_event_check_url, params: {auth_token: auth_token, id: Event.last.id}
    assert_response :success
    p response.body

    post api_event_cancel_url, params: {auth_token: auth_token, id: Event.last.id}
    assert_response :success
    p response.body

    get api_event_my_url, params: {auth_token: auth_token}
    assert_response :success
    p response.body
  end

  # test "api#event/participants" do
  #   get api_event_participants_url
  #   assert_response :success
  #   p response.body
  # end

  # test "api#event/get" do
  #   get api_event_get_url
  #   assert_response :success
  #   p response.body
  # end

  # test "api#event/join" do
  #   post api_event_join_url
  #   assert_response :success
  #   p response.body
  # end

  # test "api#event/check" do
  #   post api_event_check_url
  #   assert_response :success
  #   p response.body
  # end

  # test "api#event/cancel" do
  #   post api_event_cancel_url
  #   assert_response :success
  #   p response.body
  # end

  # test "api#event/create" do
  #   prof = Profile.find_or_create_by(address: $account_addr, username: "coderr", domain: "coderr.sociallayer.im")
  #   auth_token = gen_auth_token(prof.id)

  #   post api_event_create_url, params: {auth_token: auth_token, title: "christmas", start_time: DateTime.current, ending_time: (DateTime.current+ 1), location_type: "online", location: "http://zoom.us", content: "wonderful", cover: "", max_participant: 10, need_approval: false, host_info: "coderr@example.com"}
  #   assert_response :success
  #   p response.body
  # end
end
