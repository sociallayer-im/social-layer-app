class Badge < ApplicationRecord

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
