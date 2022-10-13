class TemplateCollection < ApplicationRecord
  belongs_to :template_library
  has_many :templates
end
