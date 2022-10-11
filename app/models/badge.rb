require 'digest/keccak'

class Badge < ApplicationRecord

  belongs_to :sender, class_name: 'Profile', foreign_key: "sender_id"

  belongs_to :subject, optional: true
  belongs_to :org, optional: true
  belongs_to :template, optional: true

  belongs_to :badge_library, optional: true
  belongs_to :badge_collection, optional: true

  has_many :badgelets

  has_many :presends

  def self.sha3raw(str)
    Digest::Keccak.digest(str, 256)
  end

  def self.tohex(binary)
    binary.unpack('H*').first
  end

  def self.get_namehash(str)
    node = "\x0" * 32
    labels = str.split(".").reverse
    puts "labels"
    p labels
    while labels.length > 0
      label = labels.shift
      labelhash = sha3raw(label)
      node = sha3raw(node+labelhash)
    end

    "0x" + tohex(node)
  end

  def self.get_badgelet_namehash(str)
    domain, index = str.split("#")
    str = if index
      "#{index}.#.#{domain}"
    else
      domain
    end
    # puts str
    get_namehash(str)
  end

  def set_token_id
    self.token_id = Badge.get_badgelet_namehash(self.domain)
    save
  end

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
