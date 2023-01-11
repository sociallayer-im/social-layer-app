Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "api/profile#home"

  get "meta/:id", to: "api/badgelet#meta"

  namespace :api, path: "" do
    get "profile/signin", to: "profile#signin"
    get "siwe/nonce", to: "profile#nonce"
    post "siwe/verify", to: "profile#verify"
    get "siwe/current", to: "profile#current"
    get "siwe/current_account", to: "profile#current_account"

    post "upload/image", to: "profile#upload_image"

    get "profile/list", to: "profile#list"
    get "profile/search", to: "profile#search"
    get "profile/get", to: "profile#get"
    post "profile/create", to: "profile#create"
    post "profile/update", to: "profile#update"
    post "profile/send_email", to: "profile#send_email"
    post "profile/signin_with_email", to: "profile#signin_with_email"
    post "profile/set_verified_address", to: "profile#set_verified_address"

    get "profile/followers", to: "profile#followers"
    get "profile/followings", to: "profile#followings"
    post "profile/follow", to: "profile#follow"
    post "profile/unfollow", to: "profile#unfollow"

    get "template/list", to: "template#list"
    get "template/get", to: "template#get"
    post "template/create", to: "template#create"

    get "subject/list", to: "subject#list"
    get "subject/get", to: "subject#get"
    post "subject/create", to: "subject#create"

    get "badge/list", to: "badge#list"
    get "badge/search", to: "badge#search"
    get "badge/get", to: "badge#get"

    post "badge/create", to: "badge#create"
    post "badge/send", to: "badge#send_badge"
    post "badge/accept", to: "badge#accept_badge"
    post "badge/reject", to: "badge#reject_badge"
    post "badge/revoke", to: "badge#revoke_badge"
    post "badge/hide", to: "badge#hide_badge"
    post "badge/top", to: "badge#top_badge"
    post "badge/unhide", to: "badge#unhide_badge"
    post "badge/untop", to: "badge#untop_badge"

    get "badgelet/list", to: "badgelet#list"
    get "badgelet/search", to: "badgelet#search"
    get "badgelet/get", to: "badgelet#get"
    get "badgelet/chainload", to: "badgelet#chainload"

    get "presend/list", to: "presend#list"
    get "presend/get", to: "presend#get"
    post "presend/create", to: "presend#create"
    post "presend/use", to: "presend#use"
    post "presend/revoke", to: "presend#revoke"

    get "event/list", to: "event#list"
    get "event/search", to: "event#search"
    get "event/my", to: "event#my"
    get "event/get", to: "event#get"
    post "event/join", to: "event#join"
    post "event/check", to: "event#check"
    post "event/cancel", to: "event#cancel"
    post "event/create", to: "event#create"
    post "event/update", to: "event#update"
    post "event/cancel_event", to: "event#cancel_event"

    get "org/list", to: "org#list"
    get "org/get", to: "org#get"
    post "org/create", to: "org#create"
    get "org/members", to: "org#members"
    post "org/add-member", to: "org#add_member"
    post "org/remove-member", to: "org#remove_member"

    get "group/list", to: "group#list"
    get "group/get", to: "group#get"
    post "group/create", to: "group#create"
    post "group/update", to: "group#update"
    get "group/members", to: "group#members"
    post "group/add-member", to: "group#add_member"
    post "group/remove-member", to: "group#remove_member"

    get "group/group-invites", to: "group#group_invites"
    post "group/send-invite", to: "group#send_invite"
    post "group/accept-invite", to: "group#accept_invite"

  end
end
