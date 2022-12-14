class Config < ApplicationRecord
  encrypts :name
  encrypts :link, deterministic: true

  scope :all_system, -> { where(source: :system) }

  has_many :coach_configs
  has_many :coaches, through: :coach_configs

  validates :link, presence: true, url: true

  before_create :generate_name
  before_create :generate_source

  def system?
    source == "system"
  end

  def customer?
    !system?
  end

  private

  def generate_source
    self.source ||= "customer"
  end
end
