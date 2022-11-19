class Api::PresendController < ApiController

  # http GET "localhost:3000/presend/list"
  def list
    @presends = Presend.includes(:badge)
    if params[:sender_id]
      @presends = @presends.where(sender_id: params[:sender_id])
    end
    @presends = @presends.page(params[:page])
    render json: {presends: @presends.as_json}
  end

  # http GET "localhost:3000/presend/get" id==1
  def get
    @presend = Presend.includes(:badge).find(params[:id])
    render json: {presend: @presend.as_json(include: :badge)}
  end

  def revoke
    profile = current_profile!
    presend = Presend.includes(:badge).find(params[:id])

    raise ActionController::ActionControllerError.new("access denied") unless presend.sender_id == profile.id
    presend.update(counter: 0)

    render json: {presend: @presend.as_json(include: :badge)}
  end

  def use
    profile = current_profile!
    presend = Presend.find(params[:id])
    badge = presend.badge

    raise ActionController::ActionControllerError.new("access denied") unless presend.code == params[:code]

    domain = "#{badge.domain}##{badge.counter}"

    @badgelet = Badgelet.new(
      index: badge.counter,
      domain: domain,
      token_id: Badge.get_badgelet_namehash(domain),
      # content: params[:content] || badge.content,
      metadata: badge.metadata,
      # subject_url: params[:subject_url],
      status: "accepted",
      badge_id: badge.id,
      sender_id: presend.sender.id,
      receiver_id: profile.id,
      owner_id: profile.id,
      presend_id: presend.id)
  
    if badgelet.content
      hashtags = badgelet.content.scan(/#\S+/)
      if hashtags
        badgelet.hashtags = hashtags
      end
    end
    @badgelet.save
    badge.increment!(:counter)

    render template: "api/badge/badgelet"
  end

  # http POST "localhost:3000/presend/create" owner_id=0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 name=GoodEvent
  def create
    profile = current_profile!
    badge = Badge.find(params[:badge_id])

    @presend = Presend.create(
      sender: profile,
      badge: badge,
      message: params[:message],
      counter: params[:counter],
      code: rand(1000000..10000000),
      expires_at: (DateTime.now+30.days),
      )
    render json: {presend: @presend.as_json}
  end

end
