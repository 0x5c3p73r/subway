class Subscribe < ApplicationRecord
  encrypts :name
  encrypts :link, deterministic: true

  has_many :coach_subscribes
  has_many :coaches, through: :coach_subscribes

  validates :link, presence: true, url: { schemes: ['http', 'https', 'ss', 'ssr', 'vmess', 'trojan'] }

  before_create :generate_name
end
