class Api::EventController < ApiController

  # http GET "localhost:3000/event/list"
  def list
    @events = Event
    if params[:owner_id]
      @events = @events.where(owner_id: params[:owner_id])
    end
    @events = @events.order('id desc').page(params[:page])

    render template: "api/event/events"
  end

  def participants
  	@participants = Participant.includes(:profile).where(event_id: profile.id)
    render json: {participant: @participant.as_json(include: :profile)}
    # render template: "api/event/participants"
  end

  def my
    profile = current_profile!
  	@participants = Participant.includes(:event).where(profile_id: profile.id)
    @participants = @participants.order('id desc').page(params[:page])
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

    @participant = Participant.create(
    	profile: profile,
    	event: @event,
        message: params[:message],
    	)

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

  # http POST "localhost:3000/event/create" owner_id=0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 name=GoodEvent
  def create
    profile = current_profile!

    @event = Event.create(
      owner: profile,
      title: params[:title],
      start_time: params[:start_time],
      ending_time: params[:ending_time],
      location_type: params[:location_type], # online | offline
      location: params[:location],
      content: params[:content],
      cover: params[:cover],
      status: "new",
      max_participant: params[:max_participant],
      need_approval: params[:need_approval],
      host_info: params[:host_info],
      )
    render json: {event: @event.as_json}
  end

end
