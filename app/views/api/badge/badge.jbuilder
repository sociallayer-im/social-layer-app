json.badge do
  json.(@badge, 
    :id, :name, :domain, :title, :metadata, :content, :image_url,
      :token_id, :template_id, :resource_type, :resource_url, :subject_url, :badge_class, :hashtags, :created_at, :unlocking, :counter)

  if @badge.badge_library
    json.badge_library do
      json.(@badge.badge_library, :id, :title, :image_url)
    end
  else
    json.badge_library nil
  end

  if @badge.badge_collection
    json.badge_collection do
      json.(@badge.badge_collection, :id, :title)
    end
  else
    json.badge_collection nil
  end

  if @badge.org
    json.org do
      json.(@badge.org, :id, :title, :name, :domain, :image_url)
    end
  else
    json.org nil
  end

  if @badge.subject
    json.subject do
      json.(@badge.subject, :id, :name, :token_id, :domain, :title, :subject_class, :subject_url, :hashtags)
    end
  else
    json.subject nil
  end

  if @badge.sender
    json.sender do
      json.id @badge.sender.id
      json.address @badge.sender.address
      json.email @badge.sender.email
      json.domain @badge.sender.domain
      json.image_url @badge.sender.image_url
    end
  else
    json.sender nil
  end

end
