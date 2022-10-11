class Badgelet < ApplicationRecord
  belongs_to :badge
  belongs_to :receiver, class_name: 'Profile', foreign_key: "receiver_id"
  belongs_to :owner, class_name: 'Profile', foreign_key: "owner_id"
  belongs_to :sender, class_name: 'Profile', foreign_key: "sender_id"

  def set_token_id
    self.token_id = Badge.get_badgelet_namehash(self.domain)
    save
  end
end
