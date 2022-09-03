class Api::BadgeController < ApiController

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
    render json: {badges: badges.all.as_json}
  end

  def search
    badges = Badge.where("title LIKE ?", "%" + params[:title] + "%")

    render json: {badges: badges}
  end

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

    unless domain.length >=4 && /[a-z0-9]+([\-\.]{1}[a-z0-9]+)*/.match(domain).to_s == domain
      render json: {result: "error", message: "invalid domain"}
      return
    end

    badge = Badge.create(
      name: params[:name],
      domain: params[:domain], # todo: verify user have parent domain name
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

  # http POST "localhost:3000/badge/send" id=1 receiver_id=0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 content=some_reason
  def send_badge
    profile = current_profile!

    raise ActionController::ActionControllerError.new("invalid receiver id") unless check_address(params[:receiver_id])

    badge = Badge.find(params[:id])
    raise ActionController::ActionControllerError.new("access denied") unless badge.issuer_id == profile.address

    badge.update(status: "pending", content: params[:content], receiver_id: params[:receiver_id], owner_id: params[:receiver_id])
    render json: {badge: badge.as_json}
  end

  # http POST "localhost:3000/badge/accept" id=1
  def accept_badge
    profile = current_profile!

    badge = Badge.find(params[:id])
    raise ActionController::ActionControllerError.new("access denied") unless badge.owner_id == profile.address

    badge.update(status: "accepted")
    render json: {badge: badge.as_json}
  end

  # http POST "localhost:3000/badge/reject" id=1
  def reject_badge
    profile = current_profile!

    badge = Badge.find(params[:id])
    raise ActionController::ActionControllerError.new("access denied") unless badge.owner_id == profile.address

    badge.update(status: "rejected")
    render json: {badge: badge.as_json}
  end

  # http POST "localhost:3000/badge/revoke" id=1
  def revoke_badge
    profile = current_profile!

    badge = Badge.find(params[:id])
    raise ActionController::ActionControllerError.new("access denied") unless badge.owner_id == profile.address || badge.issuer_id == profile.address

    badge.update(status: "revoked")
    render json: {badge: badge.as_json}
  end

end
