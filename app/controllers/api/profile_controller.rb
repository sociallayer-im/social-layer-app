require 'jwt'

class Api::ProfileController < ApiController

  def home
    render json: "ok"
  end

  def signin
    render layout: false
  end

  def nonce
    render json: {nonce: Siwe::Util.generate_nonce}
  end

  def verify
    begin
      signature = params[:signature]
      message = Siwe::Message.from_message params[:message]
      message.verify(signature, message.domain, message.issued_at, message.nonce)

      payload = {address: message.address}
      hmac_secret = Rails.application.secret_key_base
      token = JWT.encode payload, hmac_secret, 'HS256'
      render json: {result: "ok", auth_token: token}
    rescue Siwe::ExpiredMessage
        # Used when the message is already expired. (Expires At < Time.now)
        render json: {result: "error", message: "Siwe::ExpiredMessage"}
    rescue Siwe::NotValidMessage
        # Used when the message is not yet valid. (Not Before > Time.now)
        render json: {result: "error", message: "Siwe::NotValidMessage"}
    rescue Siwe::InvalidSignature
        # Used when the signature doesn't correspond to the address of the message.
        render json: {result: "error", message: "Siwe::InvalidSignature"}
    end
  end

  # http GET "localhost:3000/profile/list"
  def list
    if params[:username]
      profiles = Profile.where("username LIKE ?", "%" + params[:username] + "%")
    else
      profiles = Profile.all
    end

    render json: {profiles: profiles}
  end


  # http GET "localhost:3000/profile/get" address==0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
  # http GET "localhost:3000/profile/get" username==coder
  # http GET "localhost:3000/profile/get" domain==coder.sociallayer.im
  def get
    if params[:address]
      profile = Profile.where(address: params[:address]).first
    elsif params[:username]
      profile = Profile.where(username: params[:username]).first
    elsif params[:domain]
      profile = Profile.where(domain: params[:domain]).first
    end

    render json: {profile: profile.as_json}
  end

  # notice: image_url instead of imageUrl
  # http POST "localhost:3000/profile/update" image_url=http://example.com/img.jpg address=0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
  def update
    profile = Profile.where(address: params[:address]).first
    profile.update(image_url: params[:image_url])
    render json: {profile: profile.as_json
    }
  end

  # http POST "localhost:3000/profile/create" address=0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 username=coder
  def create
    unless params[:username].length >=4 && /[a-z0-9]+([\-\.]{1}[a-z0-9]+)*/.match(params[:username]).to_s == params[:username]
      render json: {result: "error", message: "invalid username"}
      return
    end

    domain = "#{params[:username]}.sociallayer.im"
    Profile.create(address: params[:address], username: params[:username], domain: domain)
    render json: {result: "ok"}
  end
end
