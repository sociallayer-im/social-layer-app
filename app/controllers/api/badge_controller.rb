class Api::BadgeController < ApiController

  # todo : add :page param doc
  # http GET "localhost:3000/badge/list"
  # http GET "localhost:3000/badge/list" status=pending
  def list
    @badges = Badge

    if params[:sender_id]
      @badges = @badges.where(sender_id: params[:sender_id])
    end
    # render json: {badges: badges.page(params[:page])}

    @badges = @badges.page(params[:page])
    render template: "api/badge/badges"
  end

  def search
    @badges = Badge.where("title LIKE ?", "%" + params[:title] + "%")
    if params[:sender_id]
      @badges = @badges.where(sender_id: params[:sender_id])
    end

    # render json: {badges: badges.page(params[:page]).as_json}
    @badges = @badges.page(params[:page])
    render template: "api/badge/badges"
  end

  # todo : add :page param doc
  # http GET "localhost:3000/badge/get" id==1
  # http GET "localhost:3000/badge/get" id==1 with_badgelets==1
  def get
    if params[:with_badgelets]=="1"
      @badge = Badge.includes(:badgelets).find(params[:id])
      render template: "api/badge/badge_with_badgelets"
    else
      @badge = Badge.find(params[:id])
      render template: "api/badge/badge"
    end
  end

  # http POST "localhost:3000/badge/create" name=GoodBadge title=GoodBadge domain=goodbadge content=goodbadge image_url=http://example.com/img.jpg
  def create
    profile = current_profile!
    domain = params[:domain]
    domain = domain.split('.')[0]

    unless check_badge_domain_label(domain)
      render json: {result: "error", message: "invalid domain"}
      return
    end
    domain = "#{domain}.#{profile.domain}"

    @badge = Badge.new(
      name: params[:name],
      domain: domain,
      token_id: Badge.get_badgelet_namehash(domain),
      title: params[:title],
      content: params[:content],
      metadata: params[:metadata],
      image_url: params[:image_url],
      template_id: params[:template_id], # todo : check user has template permission
      subject_id: params[:subject_id],
      org_id: params[:org_id], # todo : check user has org permission
      sender_id: profile.id,
      )
    if @badge.content
      hashtags = @badge.content.scan(/#\S+/)
      if hashtags
        @badge.hashtags = hashtags
      end
    end
    @badge.save
    render template: "api/badge/badge"
    # render json: {badge: badge.as_json}
  end

  # http POST "localhost:3000/badge/send" badge_id=1 receivers[]=0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 content='GoodBadge' auth_token==$AUTH_TOKEN
  def send_badge
    profile = current_profile!

    # todo : add check again with email input
    params[:receivers].each {|receiver| raise ActionController::ActionControllerError.new("invalid receiver id") unless check_address_or_email(receiver) }

    badge = Badge.find(params[:badge_id])
    raise ActionController::ActionControllerError.new("access denied") unless badge.sender_id == profile.id

    # todo : badgelet should copy value from badge
    @badgelets = params[:receivers].map {|receiver|
      receiver_id = Profile.find_by(address: receiver) || Profile.find_by(email: receiver) || Profile.find_by(id: receiver)
      if receiver_id.nil? && receiver.include?("@")
        receiver_id = Profile.find_or_create_by(email: receiver)
      elsif receiver_id.nil?
        receiver_id = Profile.find_or_create_by(address: receiver)
      end
      receiver_id = receiver_id.id
      domain = "#{badge.domain}##{badge.counter}"
      badgelet = Badgelet.new(
        index: badge.counter,
        domain: domain,
        token_id: Badge.get_badgelet_namehash(domain),
        content: params[:content] || badge.content,
        metadata: badge.metadata,
        subject_url: params[:subject_url],
        status: "pending",
        badge_id: badge.id,
        sender_id: profile.id,
        receiver_id: receiver_id,
        owner_id: receiver_id)

      if badgelet.content
        hashtags = badgelet.content.scan(/#\S+/)
        if hashtags
          badgelet.hashtags = hashtags
        end
      end
      badgelet.save

      badge.increment!(:counter)

      badgelet
    }

    # render json: {badgelets: badgelets.as_json}
    render template: "api/badge/badgelets"
  end

  # http POST "localhost:3000/badge/accept" badgelet_id=1
  def accept_badge
    profile = current_profile!

    @badgelet = Badgelet.find(params[:badgelet_id])

    raise ActionController::ActionControllerError.new("access denied") unless @badgelet.owner_id == profile.id
    raise ActionController::ActionControllerError.new("invalid state") unless @badgelet.status == "pending"

    @badgelet.update(status: "accepted")
    # render json: {badgelet: badgelet.as_json}
    render template: "api/badge/badgelet"
  end

  # http POST "localhost:3000/badge/reject" badgelet_id=1
  def reject_badge
    profile = current_profile!

    @badgelet = Badgelet.find(params[:badgelet_id])
    raise ActionController::ActionControllerError.new("access denied") unless @badgelet.owner_id == profile.id
    raise ActionController::ActionControllerError.new("invalid state") unless @badgelet.status == "pending"

    @badgelet.update(status: "rejected")
    # render json: {badgelet: badgelet.as_json}
    render template: "api/badge/badgelet"
  end

  # http POST "localhost:3000/badge/revoke" badgelet_id=1
  def revoke_badge
    profile = current_profile!

    @badgelet = Badgelet.find(params[:badgelet_id])
    raise ActionController::ActionControllerError.new("access denied") unless @badgelet.owner_id == profile.id || badgelet.sender_id == profile.id
    raise ActionController::ActionControllerError.new("invalid state") unless @badgelet.status == "pending" || badgelet.status == "accepted"

    @badgelet.update(status: "revoked")
    # render json: {badgelet: badgelet.as_json}
    render template: "api/badge/badgelet"
  end

  # http POST "localhost:3000/badge/hide" badgelet_id=1
  def hide_badge
    profile = current_profile!

    @badgelet = Badgelet.find(params[:badgelet_id])
    raise ActionController::ActionControllerError.new("access denied") unless @badgelet.owner_id == profile.id
    raise ActionController::ActionControllerError.new("invalid state") unless @badgelet.status == "accepted"

    @badgelet.update(hide: true)
    # render json: {badgelet: badgelet.as_json}
    render template: "api/badge/badgelet"
  end

  # http POST "localhost:3000/badge/unhide" badgelet_id=1
  def unhide_badge
    profile = current_profile!

    @badgelet = Badgelet.find(params[:badgelet_id])
    raise ActionController::ActionControllerError.new("access denied") unless @badgelet.owner_id == profile.id
    raise ActionController::ActionControllerError.new("invalid state") unless @badgelet.status == "accepted"

    @badgelet.update(hide: false)
    # render json: {badgelet: badgelet.as_json}
    render template: "api/badge/badgelet"
  end

  # http POST "localhost:3000/badge/top" badgelet_id=1
  def top_badge
    profile = current_profile!

    @badgelet = Badgelet.find(params[:badgelet_id])
    raise ActionController::ActionControllerError.new("access denied") unless @badgelet.owner_id == profile.id
    raise ActionController::ActionControllerError.new("invalid state") unless @badgelet.status == "accepted"

    @badgelet.update(top: true)
    # render json: {badgelet: badgelet.as_json}
    render template: "api/badge/badgelet"
  end

  # http POST "localhost:3000/badge/untop" badgelet_id=1
  def untop_badge
    profile = current_profile!

    @badgelet = Badgelet.find(params[:badgelet_id])
    raise ActionController::ActionControllerError.new("access denied") unless @badgelet.owner_id == profile.id
    raise ActionController::ActionControllerError.new("invalid state") unless @badgelet.status == "accepted"

    @badgelet.update(top: false)
    # render json: {badgelet: badgelet.as_json}
    render template: "api/badge/badgelet"
  end

end
