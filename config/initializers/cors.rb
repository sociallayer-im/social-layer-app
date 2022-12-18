Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'example.com', 'localhost:3000', 'localhost:8080', 'app.sociallayer.im', 'social-layer-app-dev.vercel.app', 'twitter.com', 'www.twitter.com', 'm.twitter.com'
    resource '*', headers: :any, methods: [:get, :post, :patch, :put]
  end
end