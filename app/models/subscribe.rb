class Subscribe < ApplicationRecord
  encrypts :name
  encrypts :link, deterministic: true

  has_many :coach_subscribes
  has_many :coaches, through: :coach_subscribes

  before_create :generate_name
end
