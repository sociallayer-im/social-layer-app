require 'jwt'
require 'aws-sdk'

$hmac_secret = Rails.application.secret_key_base
region = "ap-northeast-3"
$ses = Aws::SES::Client.new(region: region)

class Api::ProfileController < ApiController

  def home
    render json: {result: "ok"}
  end

  def current
    render json: current_address!
  end

  def current_account
    render json: (current_profile!).as_json
  end

  def signin
    render layout: false
  end

  # http -f POST "localhost:3000/upload/image" uploader==0x7682Ba569E3823Ca1B7317017F5769F8Aa8842D4 resource==badge data@./WechatIMG413.png
  def upload_image
    profile = current_profile!

    imagekitio = ImageKitIo::Client.new(ENV["IMAGEKIT_PRIVATE_KEY"], ENV["IMAGEKIT_PUBLIC_KEY"], ENV["IMAGEKIT_URL_ENDPOINT"])
    upload = imagekitio.upload_file(
        file: params[:data],
        file_name: params[:resource],
        response_fields: 'tags,customCoordinates,isPrivateFile,metadata',
        tags: [ENV["APP_STAGE"] || "dev"],
        custom_metadata: {
          "address": (profile && (profile.address || profile.email)),
        }
    )
    render json: {result: upload[:response]}
  end

  def nonce
    render json: {nonce: Siwe::Util.generate_nonce}
  end

  def verify
    begin
      signature = params[:signature]
      message = Siwe::Message.from_message params[:message]
      message.verify(signature, message.domain, message.issued_at, message.nonce)

      profile = Profile.find_or_create_by(address: message.address)

      payload = {id: profile.id, address_type: 'wallet'}
      auth_token = JWT.encode payload, $hmac_secret, 'HS256'
      render json: {result: "ok", auth_token: auth_token, address: message.address, id: profile.id}
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

  # http POST "localhost:3000/profile/email_signin" email=hello@mail.com
  def send_email
    code = rand(10000..100000)
    token = MailToken.create(email: params[:email], code: code)
    p token

    unless ENV["DO_NOT_SEND_EMAIL"]
      # MailerJob.perform_async(params[:email], code)

      sender = "sender@sociallayer.im"
      recipient = params[:email]
      encoding = "UTF-8"
      subject = "Social Layer SignIn"
      textbody = <<MESSAGE_END
This is an e-mail message to login sociallayer.im.
Sign In Code: #{code}
MESSAGE_END

      resp = $ses.send_email({
      destination: {
        to_addresses: [
          recipient,
        ],
      },
      message: {
        body: {
          text: {
            charset: encoding,
            data: textbody,
          },
        },
        subject: {
          charset: encoding,
          data: subject,
        },
      },
      source: sender,
      })

    end

    render json: {result: "ok", email: params[:email]}
  end

  # http POST "localhost:3000/profile/email_signin_verify" email=hello@mail.com code=18515
  def signin_with_email
    token = MailToken.find_by(email: params[:email], code: params[:code])
    return render json: {result: "error", message: "EMailSignIn::InvalidEmailOrCode"} unless token
    return render json: {result: "error", message: "EMailSignIn::Expired"} unless DateTime.now < (token.created_at + 30.minute)
    return render json: {result: "error", message: "EMailSignIn::CodeIsUsed"} unless !token.verified
    token.update(verified: true)

    profile = Profile.find_or_create_by(email: params[:email])
    payload = {id: profile.id, address_type: 'email'}
    auth_token = JWT.encode payload, $hmac_secret, 'HS256'
    render json: {result: "ok", auth_token: auth_token, email: params[:email], id: profile.id}
  end

  def set_verified_address
    profile = current_profile!

    begin
      signature = params[:signature]
      message = Siwe::Message.from_message params[:message]
      message.verify(signature, message.domain, message.issued_at, message.nonce)

      # profile = Profile.find_or_create_by(address: message.address)
      address = message.address

      addr_profile = Profile.where(address: address).first
      if addr_profile && addr_profile.username
          return render json: {result: "error", message: "profile domain name already exists"}
      end

      profile.update(address: address)
      # todo : migrate address badges

      render json: {result: "ok", email: profile.email, address: message.address, id: profile.id}
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

  # todo : add :page param doc
  def search
    profiles = Profile
    profiles = profiles.where("username LIKE ?", "%" + params[:username] + "%").or(profiles.where("email LIKE ?", "%" + params[:username] + "%"))

    render json: {profiles: profiles.page(params[:page]).as_json}
  end

  # todo : add :page param doc
  # http GET "localhost:3000/profile/list"
  def list
    if params[:username]
      profiles = Profile.where("username LIKE ?", "%" + params[:username] + "%")
    else
      profiles = Profile
    end

    render json: {profiles: profiles.page(params[:page]).as_json}
  end

  # http GET "localhost:3000/profile/get" address==0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
  # http GET "localhost:3000/profile/get" twitter==coder
  # http GET "localhost:3000/profile/get" username==coder
  # http GET "localhost:3000/profile/get" email==coder@email.com
  # http GET "localhost:3000/profile/get" domain==coder.sociallayer.im
  def get
    if params[:address]
      profile = Profile.where(address: params[:address]).first
    elsif params[:id]
      profile = Profile.find(params[:id])
    elsif params[:username]
      profile = Profile.where(username: params[:username]).first
    elsif params[:twitter]
      profile = Profile.where(twitter: params[:twitter]).first
    elsif params[:domain]
      profile = Profile.where(domain: params[:domain]).first
    elsif params[:email]
      profile = Profile.where(email: params[:email]).first
    elsif params[:any]
      profile = Profile.where(address: params[:any]).first || Profile.where(username: params[:any]).first  || Profile.where(email: params[:any]).first || Profile.where(domain: params[:any]).first
    end

    render json: {profile: profile.as_json}
  end

  # notice: image_url instead of imageUrl
  # http POST "localhost:3000/profile/update" image_url=http://example.com/img.jpg address=0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
  def update
    # profile = Profile.where(address: params[:address]).first
    profile = current_profile!
    profile.update(image_url: params[:image_url])
    render json: {profile: profile.as_json
    }
  end

  # http POST "localhost:3000/profile/create" address=0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 username=coder
  def create
    profile = current_profile

    username = params[:username]
    unless check_profile_username(username)
      render json: {result: "error", message: "invalid username"}
      return
    end

    domain = "#{params[:username]}.sociallayer.im"
    # profile = Profile.find_by(address: current_address)

    if profile
      if profile.domain
        render json: {result: "error", message: "profile domain exists"}
      else
        profile.update(username: params[:username], domain: domain)
        render json: {result: "ok"}
      end
    else
      Profile.create(address: current_address, username: params[:username], domain: domain, token_id: Badge.get_badgelet_namehash(domain))
      render json: {result: "ok"}
    end
  end
end
