json.presends @presends do |presend|
  # `presend.code` omitted
  json.(presend, :id, :sender_id, :badge_id, :badgelet_id, :message, :counter, :accepted, :expires_at, :created_at, :updated_at)
  if @show_presend_code_sender_id && presend.sender_id == @show_presend_code_sender_id
    json.code presend.code
  end

  json.badge do
  json.(presend.badge, 
    :id, :name, :domain, :title, :metadata, :content, :image_url,
      :token_id, :template_id, :resource_type, :resource_url, :subject_url, :badge_class, :hashtags, :unlocking, :counter)
  end
end
