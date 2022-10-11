class Profile < ApplicationRecord

  has_many :presends, inverse_of: 'sender'

  has_many :received_badgelets, class_name: 'Badgelet', inverse_of: 'receiver'
  has_many :owned_badgelets, class_name: 'Badgelet', inverse_of: 'owner'
  has_many :sent_badgelets, class_name: 'Badgelet', inverse_of: 'sender'

  has_many :memberships

  def set_token_id
    self.token_id = Badge.get_badgelet_namehash(self.domain)
    save
  end

  rails_admin do 
    list do
      configure :image_url do
        formatted_value do
          bindings[:view].tag(:img, { :src => bindings[:object].image_url, :width => 100 }) << value
        end
      end
    end
  end
end
