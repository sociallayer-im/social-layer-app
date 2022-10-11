class Org < ApplicationRecord
  has_many :memberships
  has_many :badges
end
