json.badgelet do
  json.(@badgelet, :id, :badge_id, :status, :metadata, :content, :subject_url, :domain, :token_id)
  json.receiver do
  	json.id @badgelet.receiver.id
  	json.address @badgelet.receiver.address
  	json.email @badgelet.receiver.email
  	json.domain @badgelet.receiver.domain
  end
  json.owner do
  	json.id @badgelet.owner.id
  	json.address @badgelet.owner.address
  	json.email @badgelet.owner.email
  	json.domain @badgelet.owner.domain
  end
  json.sender do
  	json.id @badgelet.sender.id
  	json.address @badgelet.sender.address
  	json.email @badgelet.sender.email
  	json.domain @badgelet.sender.domain
  end
  json.badge do
  	json.(@badgelet.badge, 
  		:id, :name, :domain, :title, :metadata, :content, :image_url,
        :token_id, :template_id, :subject_id, :org_id, :resource_type, :resource_url, :subject_url, :badge_class, :hashtags, :badge_library_id, :badge_collection_id, :value, :last_consumed_at, :unlocking, :counter) 
  end
end
