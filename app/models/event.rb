class Event < ApplicationRecord
  belongs_to :owner, class_name: 'Profile', foreign_key: "owner_id"
  has_many :participants
end
