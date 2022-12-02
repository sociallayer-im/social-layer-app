json.event do
  json.(@event, 
    :id, :title, :start_time, :ending_time, :location_type, :location, :owner_id,
      :org_id, :content, :cover, :status, :max_participant, :need_approval, :host_info, :created_at, :updated_at)

  json.participants @event.participants do |participant|
    json.(participant, :message, :check_time, :status, :created_at) 

    if participant.profile
      json.profile do
        json.id participant.profile.id
        json.address participant.profile.address
        json.email participant.profile.email
        json.domain participant.profile.domain
        json.image_url participant.profile.image_url
      end
    else
      json.profile nil
    end
  end
end
