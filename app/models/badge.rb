class Badge < ApplicationRecord

  belongs_to :sender, class_name: 'Profile', foreign_key: "sender_id"

  belongs_to :subject, optional: true
  belongs_to :org, optional: true
  belongs_to :template, optional: true

  belongs_to :badge_library, optional: true
  belongs_to :badge_collection, optional: true

  has_many :badgelets

  has_many :presends

  rails_admin do 
    list do
      configure :image_url do
        formatted_value do
          bindings[:view].tag(:img, { :src => bindings[:object].image_url, :width => 100 }) << value
        end
      end
    end
  end
end
