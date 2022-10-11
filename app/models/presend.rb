class Presend < ApplicationRecord

  belongs_to :sender, class_name: "Profile", foreign_key: 'sender_id'
  belongs_to :badge

end
