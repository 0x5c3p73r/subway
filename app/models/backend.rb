class Backend < ApplicationRecord
  include HttpRequest

  has_many :coach_backends
  has_many :coaches, through: :coach_backends

  encrypts :name
  encrypts :link, deterministic: true

  scope :all_system, -> { where(source: :system) }

  validates :link, presence: true, url: true

  before_create :generate_name
  before_create :generate_source
  after_save :perform_version_check

  def system?
    source == "system"
  end

  def customer?
    !system?
  end

  def subconverter_url
    File.join(link, "sub")
  end

  def version_check
    res = fetch(version_url)
    _, version, _ = res.body.split(" ")

    update_column(:version, version)
  rescue
    # ignore update, may be this api blocked by reverse proxy service.
  end

  private

  def perform_version_check
    BackendVersionCheckerJob.perform_later(backend_id: id)
  end

  def version_url
    File.join(link, "version")
  end

  def generate_source
    self.source ||= "customer"
  end
end
