class Api::EventController < ApiController

  # http GET "localhost:3000/event/list"
  def list
    @events = Event
    if params[:owner_id]
      @events = @events.where(owner_id: params[:owner_id])
    end
    if params[:tag]
      @events = @events.where("? = ANY (tags)", params[:tag])
    end
    @events = @events.order('id desc').page(params[:page]).per(20)

    render template: "api/event/events"
  end

  def search
    @events = Event.where("title LIKE ?", "%" + params[:title] + "%")

    @events = @events.order('id desc').page(params[:page]).per(20)
    render template: "api/event/events"
  end

  def my
    profile = current_profile!
    @participants = Participant.includes(:event).where(profile_id: profile.id)
    @participants = @participants.order('id desc').page(params[:page]).per(20)
    render template: "api/event/participating"
  end

  # http GET "localhost:3000/event/get" id==1
  def get
    @event = Event.find(params[:id])

    render template: "api/event/event"
  end

  def join
    profile = current_profile!
    @event = Event.find(params[:id])

    @participant = Participant.find_by(event_id: params[:id], profile_id: profile.id)
    if @participant
      @participant.update(status: "new", message: params[:message])
    else
      @participant = Participant.create(
        profile: profile,
        event: @event,
          message: params[:message],
        )
    end

    render json: {participant: @participant.as_json}
  end

  def check
    profile = current_profile!
    event = Event.find(params[:id])

    @participant = Participant.find_by(event_id: params[:id], profile_id: profile.id)
    @participant.status = "checked"
    @participant.save

    render json: {participant: @participant.as_json}
  end

  def cancel
    profile = current_profile!
    event = Event.find(params[:id])

    @participant = Participant.find_by(event_id: params[:id], profile_id: profile.id)
    @participant.status = "cancel"
    @participant.save

    render json: {participant: @participant.as_json}
  end

  # http POST "localhost:3000/event/create"
  def create
    profile = current_profile!

    @event = Event.create(
      owner: profile,
      title: params[:title],
      category: params[:category],
      tags: params[:tags],
      start_time: params[:start_time],
      ending_time: params[:ending_time],
      location_type: params[:location_type], # online | offline | both
      location: params[:location],
      online_location: params[:online_location],
      content: params[:content],
      cover: params[:cover],
      status: "new",
      max_participant: params[:max_participant],
      need_approval: params[:need_approval],
      host_info: params[:host_info],
      )
    render json: {event: @event.as_json}
  end

  # http POST "localhost:3000/event/update"
  def update
    profile = current_profile!

    @event = Event.find(params[:id])
    raise ActionController::ActionControllerError.new("access denied") unless @event.owner_id == profile.id

    @event.update(
      title: params[:title],
      category: params[:category],
      tags: params[:tags],
      start_time: params[:start_time],
      ending_time: params[:ending_time],
      location_type: params[:location_type], # online | offline | both
      location: params[:location],
      online_location: params[:online_location],
      content: params[:content],
      cover: params[:cover],
      max_participant: params[:max_participant],
      need_approval: params[:need_approval],
      host_info: params[:host_info],
      )
    render json: {event: @event.as_json}
  end

  # http POST "localhost:3000/event/cancel_event"
  def cancel_event
    profile = current_profile!

    @event = Event.find(params[:id])
    raise ActionController::ActionControllerError.new("access denied") unless @event.owner_id == profile.id
    @event.update(status: "cancel")

    render json: {event: @event.as_json}
  end

end
