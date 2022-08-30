require 'jwt'

$hmac_secret = Rails.application.secret_key_base

class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token

  def current_address
    return @address if @address

    begin
      token = params[:auth_token]
      decoded_token = JWT.decode token, $hmac_secret, true, { algorithm: 'HS256' }
      @address = decoded_token[0]["address"]
      @address
    rescue
      nil
    end
  end

  def current_address!
    address = current_address
    raise ActionController::ActionControllerError.new("current_address is empty") unless address
    address
  end

  def current_profile!
    return @profile if @profile

    address = current_address
    raise ActionController::ActionControllerError.new("current_address is empty") unless address
    @profile = Profile.find_by(address: address)
    raise ActionController::ActionControllerError.new("profile not found") unless address
    @profile
  end

  rescue_from ActionController::ActionControllerError do |err|
    Rails.logger.info err.message
    render json: { result: 'error', message: err.message }, status: 403
  end
end
