class Following < ApplicationRecord
  belongs_to :profile
  belongs_to :target, class_name: 'Profile', foreign_key: "target_id"
end
