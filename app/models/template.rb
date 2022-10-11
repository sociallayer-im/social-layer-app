class Template < ApplicationRecord
  belongs_to :owner, class_name: 'Profile', foreign_key: 'owner_id'
  belongs_to :template_collection
  belongs_to :template_library
end
