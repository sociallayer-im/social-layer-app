class Profile < ApplicationRecord
  has_many :presends, class_name: 'Presend', inverse_of: 'sender', foreign_key: "sender_id"
  has_many :received_badgelets, class_name: 'Badgelet', inverse_of: 'receiver', foreign_key: "receiver_id"
  has_many :owned_badgelets, class_name: 'Badgelet', inverse_of: 'owner', foreign_key: "owner_id"
  has_many :sent_badgelets, class_name: 'Badgelet', inverse_of: 'sender', foreign_key: "sender_id"
  has_many :memberships

  has_many :followships, class_name: 'Following'
  has_many :followship_items, class_name: 'Following', inverse_of: 'target', foreign_key: "target_id"

  has_many :followings, :through => :followships, :source => 'target'
  has_many :followers, :through => :followship_items, :source => 'profile', foreign_key: "target_id"

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
