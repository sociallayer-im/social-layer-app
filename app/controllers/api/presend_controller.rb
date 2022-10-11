class Api::PresendController < ApiController

  # http GET "localhost:3000/presend/list"
  def list
    @presends = Presend.includes(:badge).page(params[:page])
    render json: {presends: @presends.as_json}
  end

  # http GET "localhost:3000/presend/get" id==1
  def get
    @presend = Presend.find(params[:id])
    render json: {presend: @presend.includes(:badge).as_json(include: :badge)}
  end

  def revoke
    profile = current_profile!
    presend = Presend.find(params[:id])

    raise ActionController::ActionControllerError.new("access denied") unless presend.sender_id == profile.id
    presend.update(counter: 0)

    render json: {presend: @presend.includes(:badge).as_json(include: :badge)}
  end

  def use
    render json: "ok"
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
