json.presend do
  json.(@presend, :id, :sender_id, :badge_id, :badgelet_id, :code, :message, :counter, :accepted, :expires_at, :created_at, :updated_at)

  json.badge do
    json.(@presend.badge,
    :id, :name, :domain, :title, :metadata, :content, :image_url,
      :token_id, :template_id, :resource_type, :resource_url, :subject_url, :badge_class, :hashtags, :unlocking, :counter)

    if @presend.badge.sender
      json.sender do
        json.id @presend.badge.sender.id
        json.address @presend.badge.sender.address
        json.email @presend.badge.sender.email
        json.domain @presend.badge.sender.domain
        json.image_url @presend.badge.sender.image_url
      end
    else
      json.sender nil
    end
  end

  json.badgelets @presend.badge.badgelets do |badgelet|
    json.(badgelet, :id, :badge_id, :hide, :top, :status, :metadata, :content, :subject_url, :domain, :token_id, :value, :last_consumed_at)
    
    if badgelet.receiver
      json.receiver do
        json.id badgelet.receiver.id
        json.address badgelet.receiver.address
        json.email badgelet.receiver.email
        json.domain badgelet.receiver.domain
        json.image_url badgelet.receiver.image_url
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
        json.image_url badgelet.owner.image_url
      end
    else
      json.owner nil
    end
  end
end

