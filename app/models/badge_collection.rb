class BadgeCollection < ApplicationRecord
  has_many :badges
  belongs_to :badge_collection, optional: true
end
