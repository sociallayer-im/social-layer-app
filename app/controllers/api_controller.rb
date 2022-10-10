require 'jwt'

$hmac_secret = Rails.application.secret_key_base

class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token

  def check_address(addr)
    (addr =~ /^0x[a-fA-F0-9]{40}$/) == 0 || (addr =~ URI::MailTo::EMAIL_REGEXP) == 0
  end

  def current_address
    return @address if @address

    begin
      token = params[:auth_token]
      decoded_token = JWT.decode token, $hmac_secret, true, { algorithm: 'HS256' }
      profile_id = decoded_token[0]["id"]
      @address = Profile.find(profile_id).address
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
    return @address if @address

    token = params[:auth_token]
    decoded_token = JWT.decode token, $hmac_secret, true, { algorithm: 'HS256' }
    profile_id = decoded_token[0]["id"]
    @profile = Profile.find_by(id: profile_id)
    raise ActionController::ActionControllerError.new("profile not found") unless @profile
    @profile
  end

  rescue_from ActionController::ActionControllerError do |err|
    Rails.logger.info err.message
    render json: { result: 'error', message: err.message }, status: 403
  end
end
