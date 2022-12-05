class Api::PresendController < ApiController

  # http GET "localhost:3000/presend/list"
  def list
    @presends = Presend.includes(:badge)
    if params[:sender_id]
      @presends = @presends.where(sender_id: params[:sender_id])
    end
    @presends = @presends.order('id desc').page(params[:page]).per(20)

    @profile = current_profile
    if @profile && params[:sender_id] && params[:sender_id] == @profile.id.to_s
      @show_presend_code = true
    end

    # @show_presend_code = true

    render template: "api/presend/presends"
  end

  # http GET "localhost:3000/presend/get" id==1
  def get
    @presend = Presend.includes(:badge).find(params[:id])

    @profile = current_profile
    if @profile && params[:sender_id] && params[:sender_id] == @profile.id.to_s
      @show_presend_code = true
    end

    render template: "api/presend/presend"
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

    unless presend.code.to_s == params[:code].to_s
      render json: { result: "error" , message: "presend code is empty or incorrect"}
      return
    end
    unless Badgelet.where(presend_id: params[:id], receiver_id: profile.id).blank?
      render json: { result: "error" , message: "user has already claimed presend"}
      return
    end

    domain = "#{badge.domain}##{badge.counter}"

    @badgelet = Badgelet.new(
      index: badge.counter,
      domain: domain,
      token_id: Badge.get_badgelet_namehash(domain),
      content: presend.message || badge.content,
      metadata: badge.metadata,
      # subject_url: params[:subject_url],
      status: "accepted",
      badge_id: badge.id,
      sender_id: presend.sender.id,
      receiver_id: profile.id,
      owner_id: profile.id,
      presend_id: presend.id)
  
    if @badgelet.content
      hashtags = @badgelet.content.scan(/#\S+/)
      if hashtags
        @badgelet.hashtags = hashtags
      end
    end
    @badgelet.save
    presend.decrement!(:counter)
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
