json.badge do
  json.(@badge, 
    :id, :name, :domain, :title, :metadata, :content, :image_url,
      :token_id, :template_id, :resource_type, :resource_url, :subject_url, :badge_class, :hashtags, :unlocking, :counter)

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

  json.sender do
  	json.id @badge.sender.id
  	json.address @badge.sender.address
  	json.email @badge.sender.email
  	json.domain @badge.sender.domain
  end

  json.badgelets @badge.badgelets do |badgelet|
    json.(badgelet, :id, :badge_id, :status, :metadata, :content, :subject_url, :domain, :token_id, :value, :last_consumed_at)
    
    if badgelet.receiver
      json.receiver do
        json.id badgelet.receiver.id
        json.address badgelet.receiver.address
        json.email badgelet.receiver.email
        json.domain badgelet.receiver.domain
      end
    else
      json.receiver nil
    end

    if badgelet.owner
      json.owner do
        json.id badgelet.owner.id
        json.address badgelet.owner.address
        json.email badgelet.owner.email
        json.domain badgelet.owner.domain
      end
    else
      json.owner nil
    end

  end
end
