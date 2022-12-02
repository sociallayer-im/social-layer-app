json.events @events do |event|
  json.(event, 
    :id, :title, :start_time, :ending_time, :location_type, :location, :owner_id,
      :org_id, :content, :cover, :status, :max_participant, :need_approval, :host_info, :created_at, :updated_at)
end
