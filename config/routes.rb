Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "api/profile#home"

  namespace :api, path: "" do
    get "profile/signin", to: "profile#signin"
    get "siwe/nonce", to: "profile#nonce"
    post "siwe/verify", to: "profile#verify"
    get "siwe/current", to: "profile#current"

    post "upload/image", to: "profile#upload_image"

    get "profile/list", to: "profile#list"
    get "profile/search", to: "profile#search"
    get "profile/get", to: "profile#get"
    post "profile/create", to: "profile#create"
    post "profile/update", to: "profile#update"
    post "profile/send_email", to: "profile#send_email"
    post "profile/signin_with_email", to: "profile#signin_with_email"
    post "profile/set_verified_address", to: "profile#set_verified_address"

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

    get "badgelet/list", to: "badgelet#list"
    get "badgelet/search", to: "badgelet#search"
    get "badgelet/get", to: "badgelet#get"

    get "presend/list", to: "presend#list"
    get "presend/get", to: "presend#get"
    post "presend/create", to: "presend#create"
    post "presend/use", to: "presend#use"
    post "presend/revoke", to: "presend#revoke"

    get "org/list", to: "org#list"
    get "org/get", to: "org#get"
    post "org/create", to: "org#create"
    get "org/members", to: "org#members"
    post "org/add-member", to: "org#add_member"
    post "org/remove-member", to: "org#remove_member"
  end
end
