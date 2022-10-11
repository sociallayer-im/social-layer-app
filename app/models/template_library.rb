class TemplateLibrary < ApplicationRecord
  has_many :template_libraries
  has_many :templates

  belongs_to :owner, class_name: 'Profile', foreign_key: 'owner_id'
end
