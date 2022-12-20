require 'jwt'


$hmac_secret = Rails.application.secret_key_base

class ApiController < ApplicationController
  skip_before_action :verify_authenticity_token

  def check_address_or_email(addr)
    (addr =~ /^0x[a-fA-F0-9]{40}$/) == 0 || (addr =~ URI::MailTo::EMAIL_REGEXP) == 0
  end

  def check_badge_domain_label(domain)
    (domain.length >=4) && ((domain =~ /^[a-z0-9]+([\-\.]{1}[a-z0-9]+)*$/) == 0)
  end

  def check_profile_username(username)
    username.length >=6 && /^[a-z0-9]+([\-]{1}[a-z0-9]+)*$/.match(username).to_s == username
  end

  def current_address
    return @address if @address

    begin
      token = params[:auth_token]
      decoded_token = JWT.decode token, $hmac_secret, true, { algorithm: 'HS256' }
      profile_id = decoded_token[0]["id"]
      @address = Profile.find(profile_id).address
      @address
    rescue Exception => err
      puts err.message
      Rails.logger.info err.message
      nil
    end
  end

  def current_address!
    return @address if @address

    begin
      token = params[:auth_token]
      decoded_token = JWT.decode token, $hmac_secret, true, { algorithm: 'HS256' }
      profile_id = decoded_token[0]["id"]
      @address = Profile.find(profile_id).address
      @address
    rescue Exception => err
      puts err.message
      Rails.logger.info err.message
      raise ActionController::ActionControllerError.new(err.message)
    end
  end

  def current_profile
    return Profile.find_by(address: @address) if @address

    begin
      token = params[:auth_token]
      decoded_token = JWT.decode token, $hmac_secret, true, { algorithm: 'HS256' }
      profile_id = decoded_token[0]["id"]
      @profile = Profile.find_by(id: profile_id)
    rescue Exception => err
      p err.message
      Rails.logger.info err.message
      nil
    end
  end

  def current_profile!
    return Profile.find_by(address: @address) if @address

    raise ActionController::ActionControllerError.new("auth_token is missing") unless params[:auth_token]

    begin
    token = params[:auth_token]
    decoded_token = JWT.decode token, $hmac_secret, true, { algorithm: 'HS256' }
    profile_id = decoded_token[0]["id"]
    @profile = Profile.find_by(id: profile_id)
    rescue Exception => err
      p err.message
      Rails.logger.info err.message
      raise ActionController::ActionControllerError.new(err.message)
    end

    raise ActionController::ActionControllerError.new("profile is not found") unless @profile
    @profile
  end

  rescue_from ActionController::ActionControllerError do |err|
    Rails.logger.info err.message
    render json: { result: 'error', message: err.message }, status: 403
  end
end
