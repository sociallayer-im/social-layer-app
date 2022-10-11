class BadgeLibrary < ApplicationRecord

  has_many :badges
  has_many :badge_collections

end
