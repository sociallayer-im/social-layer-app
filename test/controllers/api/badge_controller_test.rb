require "test_helper"

class Api::BadgeControllerTest < ActionDispatch::IntegrationTest

  test "api#badge/create" do
    prof = Profile.find_or_create_by(address: $account_addr, username: "coderr", domain: "coderr.sociallayer.im")
    auth_token = gen_auth_token(prof.id)


    post api_badge_create_url, params: {auth_token: auth_token, name: "GoodBadge", title: "GoodBadge",  domain: "goodbadge", image_url: "http://example.com/img.jpg"}
    assert_response :success
    p response.body

    badge_id = JSON.parse(response.body)["badge"]["id"]


    post api_badge_send_url, params: {auth_token: auth_token, badge_id: badge_id, receivers: [$account_addr], content: "good badge"}
    assert_response :success
    p response.body
    badgelet_id = JSON.parse(response.body)["badgelets"].first["id"]

    post api_badge_accept_url, params: {auth_token: auth_token, badgelet_id: badgelet_id}
    assert_response :success
    p response.body

    get api_badge_list_url, params: {auth_token: auth_token}
    assert_response :success
    JSON.parse(response.body)["badges"].each {|badge|
      p badge
    }

    get api_badge_search_url, params: {auth_token: auth_token, title: "Good"}
    assert_response :success
    JSON.parse(response.body)["badges"].each {|badge|
      p badge
    }

    get api_badgelet_list_url, params: {auth_token: auth_token}
    assert_response :success
    JSON.parse(response.body)["badgelets"].each {|badgelet|
      p badgelet
    }

    get api_badgelet_search_url, params: {auth_token: auth_token, title: "Good"}
    assert_response :success
    JSON.parse(response.body)["badgelets"].each {|badgelet|
      p badgelet
    }

    get api_badgelet_get_url, params: {auth_token: auth_token, id: Badgelet.last.id}
    assert_response :success
    p JSON.parse(response.body)["badgelet"]

    get api_badge_get_url, params: {auth_token: auth_token, id: Badge.last.id}
    assert_response :success
    p JSON.parse(response.body)["badge"]

    get api_badge_get_url, params: {auth_token: auth_token, id: Badge.last.id, with_badgelets: "1"}
    assert_response :success
    p JSON.parse(response.body)["badge"]
  end

end
