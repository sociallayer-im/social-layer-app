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
        render json: {result: "error"}
    rescue Siwe::NotValidMessage
        # Used when the message is not yet valid. (Not Before > Time.now)
        render json: {result: "error"}
    rescue Siwe::InvalidSignature
        # Used when the signature doesn't correspond to the address of the message.
        render json: {result: "error"}
    end

  end

  def list
    render json: "ok"
  end

  def get
    render json: "ok"
  end

  def update
    render json: "ok"
  end

  def create
    render json: "ok"
  end
end
