class Subject < ApplicationRecord
  has_many :badges
  belongs_to :owner, class_name: 'Profile', foreign_key: 'owner_id'
end
