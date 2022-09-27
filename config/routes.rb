Rails.application.routes.draw do
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
    post "profile/email_signin", to: "profile#email_signin"
    post "profile/email_signin_verify", to: "profile#email_signin_verify"

    get "template/list", to: "template#list"
    get "template/get", to: "template#get"
    post "template/create", to: "template#create"

    get "subject/list", to: "subject#list"
    get "subject/get", to: "subject#get"
    post "subject/create", to: "subject#create"

    get "badge/list", to: "badge#list"
    get "badge/search", to: "badge#search"
    get "badge/get", to: "badge#get"
    get "badge/get_badge_set", to: "badge#get_badge_set"

    post "badge/create", to: "badge#create"
    post "badge/create_set", to: "badge#create_set"
    post "badge/send", to: "badge#send_badge"
    post "badge/send_batch", to: "badge#send_batch"
    post "badge/accept", to: "badge#accept_badge"
    post "badge/reject", to: "badge#reject_badge"
    post "badge/revoke", to: "badge#revoke_badge"

    get "org/list", to: "org#list"
    get "org/get", to: "org#get"
    post "org/create", to: "org#create"
    get "org/members", to: "org#members"
    post "org/add-member", to: "org#add_member"
    post "org/remove-member", to: "org#remove_member"

    post "upload/image", to: "badge#upload_image"
  end
end
