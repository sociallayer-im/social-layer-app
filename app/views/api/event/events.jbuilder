json.events @events do |event|
  json.(event, 
    :id, :title, :category, :tags, :start_time, :ending_time, :location_type, :location, :online_location, :owner_id,
      :org_id, :content, :cover, :status, :max_participant, :need_approval, :host_info, :created_at, :updated_at)
end
