json.presend do
  json.(@presend, :id, :sender_id, :badge_id, :badgelet_id, :code, :message, :counter, :accepted, :expires_at, :created_at, :updated_at)

  json.badge do
  json.(@presend.badge, 
    :id, :name, :domain, :title, :metadata, :content, :image_url,
      :token_id, :template_id, :resource_type, :resource_url, :subject_url, :badge_class, :hashtags, :unlocking, :counter)
  end
end

