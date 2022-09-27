class Api::BadgeController < ApiController

  # todo : add :page param doc
  # http GET "localhost:3000/badge/list"
  # http GET "localhost:3000/badge/list" status=pending
  def list
    badges = Badge
    if params[:status]
      badges = badges.where(status: params[:status])
    end
    if params[:issuer_id]
      badges = badges.where(issuer_id: params[:issuer_id])
    end
    if params[:receiver_id]
      badges = badges.where(receiver_id: params[:receiver_id])
    end
    if params[:owner_id]
      badges = badges.where(owner_id: params[:owner_id])
    end
    render json: {badges: badges.page(params[:page]).as_json}
  end

  def search
    badges = Badge.where("title LIKE ?", "%" + params[:title] + "%")

    render json: {badges: badges.page(params[:page]).as_json}
  end

  # todo : add :page param doc
  # http GET "localhost:3000/badge/get" id==1
  def get
    badge = Badge.find(params[:id])
    render json: {badge: badge.as_json}
  end

  # http POST "localhost:3000/badge/create" issuer_id=0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 name=GoodBadge title=GoodBadge domain=goodbadge content=goodbadge image_url=http://example.com/img.jpg
  def create
    profile = current_profile!
    domain = params[:domain]
    domain = domain.split('.')[0]

    unless domain.length >=4 && /^[a-z0-9]+([\-\.]{1}[a-z0-9]+)*$/.match(domain).to_s == domain
      render json: {result: "error", message: "invalid domain"}
      return
    end
    domain = "#{domain}.#{profile.domain}"

    badge = Badge.create(
      name: params[:name],
      domain: domain,
      title: params[:title],
      content: params[:content],
      metadata: params[:metadata],
      image_url: params[:image_url],
      signature: params[:signature],
      template_id: params[:template_id],
      subject_id: params[:subject_id],
      org_id: params[:org_id],
      issuer_id: profile.address,
      )
    render json: {badge: badge.as_json}
  end

  # http POST "localhost:3000/badge/create_set" issuer_id=0x7682Ba569E3823Ca1B7317017F5769F8Aa8842D4 name=GoodBadge title=GoodBadge domain=goodbadge content=goodbadge image_url=http://example.com/img.jpg auth_token==$AUTH_TOKEN
  def create_set
    profile = current_profile!
    domain = params[:domain]
    domain = domain.split('.')[0]

    unless domain.length >=4 && /^[a-z0-9]+([\-\.]{1}[a-z0-9]+)*$/.match(domain).to_s == domain
      render json: {result: "error", message: "invalid domain"}
      return
    end
    domain = "#{domain}.#{profile.domain}"

    badge_set = BadgeSet.create(
      name: params[:name],
      domain: domain,
      title: params[:title],
      content: params[:content],
      metadata: params[:metadata],
      image_url: params[:image_url],
      template_id: params[:template_id],
      subject_id: params[:subject_id],
      org_id: params[:org_id],
      issuer_id: profile.address,
      )
    render json: {badge_set: badge_set.as_json}
  end

  # http POST "localhost:3000/badge/send" badge_set_id=1 receiver_id=0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 content='GoodBadge' auth_token==$AUTH_TOKEN
  def send_badge
    profile = current_profile!

    raise ActionController::ActionControllerError.new("invalid receiver id") unless check_address(params[:receiver_id])

    badge_set = BadgeSet.find(params[:badge_set_id])
    raise ActionController::ActionControllerError.new("access denied") unless badge_set.issuer_id == profile.address

    badge = Badge.create(
      name: badge_set.name,
      domain: "#{badge_set.domain}##{badge_set.counter}",
      title: badge_set.title,
      content: params[:content] || badge_set.content,
      metadata: badge_set.metadata,
      image_url: badge_set.image_url,
      template_id: badge_set.template_id,
      subject_id: badge_set.subject_id,
      org_id: badge_set.org_id,
      issuer_id: profile.address,
      badge_set_id: badge_set.id,
      status: "pending", content: params[:content], receiver_id: params[:receiver_id], owner_id: params[:receiver_id])

    badge_set.increment!(:counter)
    render json: {badge: badge.as_json}
  end

  # http POST "localhost:3000/badge/send_batch" badge_set_id=1 receivers[]=0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 content='GoodBadge' auth_token==$AUTH_TOKEN
  def send_batch
    profile = current_profile!

    params[:receivers].each {|receiver| raise ActionController::ActionControllerError.new("invalid receiver id") unless check_address(receiver) }

    badge_set = BadgeSet.find(params[:badge_set_id])
    raise ActionController::ActionControllerError.new("access denied") unless badge_set.issuer_id == profile.address

    # todo : badge_set.counter should start at 1
    badges = params[:receivers].map {|receiver|
      badge = Badge.create(
        name: badge_set.name,
        domain: "#{badge_set.domain}##{badge_set.counter+1}",
        title: badge_set.title,
        content: params[:content] || badge_set.content,
        metadata: badge_set.metadata,
        image_url: badge_set.image_url,
        template_id: badge_set.template_id,
        subject_id: badge_set.subject_id,
        org_id: badge_set.org_id,
        issuer_id: profile.address,
        badge_set_id: badge_set.id,
        status: "pending", content: params[:content], receiver_id: receiver, owner_id: receiver)

      badge_set.increment!(:counter)

      badge
    }

    render json: {badges: badges.as_json}
  end

  # http POST "localhost:3000/badge/accept" id=1
  def accept_badge
    profile = current_profile!

    badge = Badge.find(params[:id])
    raise ActionController::ActionControllerError.new("access denied") unless badge.owner_id == profile.address
    raise ActionController::ActionControllerError.new("invalid state") unless badge.status == "pending"

    badge.update(status: "accepted")
    render json: {badge: badge.as_json}
  end

  # http POST "localhost:3000/badge/reject" id=1
  def reject_badge
    profile = current_profile!

    badge = Badge.find(params[:id])
    raise ActionController::ActionControllerError.new("access denied") unless badge.owner_id == profile.address
    raise ActionController::ActionControllerError.new("invalid state") unless badge.status == "pending"

    badge.update(status: "rejected")
    render json: {badge: badge.as_json}
  end

  # http POST "localhost:3000/badge/revoke" id=1
  def revoke_badge
    profile = current_profile!

    badge = Badge.find(params[:id])
    raise ActionController::ActionControllerError.new("access denied") unless badge.owner_id == profile.address || badge.issuer_id == profile.address
    raise ActionController::ActionControllerError.new("invalid state") unless badge.status == "pending" || badge.status == "accepted"

    badge.update(status: "revoked")
    render json: {badge: badge.as_json}
  end

end
