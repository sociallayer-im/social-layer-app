json.badgelet do
  json.(@badgelet, :id, :badge_id, :hide, :top, :status, :metadata, :content, :hashtags, :chain_data, :subject_url, :domain, :token_id, :created_at, :value, :last_consumed_at)

  if @badgelet.receiver
    json.receiver do
      json.id @badgelet.receiver.id
      json.address @badgelet.receiver.address
      json.email @badgelet.receiver.email
      json.domain @badgelet.receiver.domain
      json.image_url @badgelet.receiver.image_url
    end
  else
    json.receiver nil
  end

  if @badgelet.owner
    json.owner do
      json.id @badgelet.owner.id
      json.address @badgelet.owner.address
      json.email @badgelet.owner.email
      json.domain @badgelet.owner.domain
      json.image_url @badgelet.owner.image_url
    end
  else
    json.owner nil
  end

  if @badgelet.sender
    json.sender do
      json.id @badgelet.sender.id
      json.address @badgelet.sender.address
      json.email @badgelet.sender.email
      json.domain @badgelet.sender.domain
      json.image_url @badgelet.sender.image_url
    end
  else
    json.sender nil
  end

  json.badge do
    json.(@badgelet.badge,
      :id, :name, :domain, :title, :metadata, :content, :image_url,
        :token_id, :template_id, :resource_type, :resource_url, :subject_url, :badge_class, :hashtags, :unlocking, :counter)

    if @badgelet.badge.badge_library
      json.badge_library do
        json.(@badgelet.badge.badge_library, :id, :title, :image_url)
      end
    else
      json.badge_library nil
    end

    if @badgelet.badge.badge_collection
      json.badge_collection do
        json.(@badgelet.badge.badge_collection, :id, :title)
      end
    else
      json.badge_collection nil
    end

    if @badgelet.badge.org
      json.org do
        json.(@badgelet.badge.org, :id, :title, :name, :domain, :image_url)
      end
    else
      json.org nil
    end

    if @badgelet.badge.subject
      json.subject do
        json.(@badgelet.badge.subject, :name, :token_id, :domain, :title, :subject_class, :subject_url, :hashtags)
      end
    else
      json.subject nil
    end
  end
end

