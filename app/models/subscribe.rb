class Subscribe < ApplicationRecord
  include HttpRequest

  encrypts :name
  encrypts :link, deterministic: true

  has_many :coach_subscribes
  has_many :coaches, through: :coach_subscribes

  validates :link, presence: true, url: { schemes: ['http', 'https', 'ss', 'ssr', 'vmess', 'trojan'] }

  before_create :generate_name

  def bandwidth_check
    # Subscription-Userinfo: upload=%f; download=%f; total=%f; expire=%f
    # 上行流量、下行流量、流量总量、过期时间 (unit timestamp in utc zone)
    head_response = head(link)
    if head_response.success? && (userinfo = head_response.headers['subscription-userinfo'])
      upload, download, total, expired_time = userinfo.split('; ').map { |s| s.split('=')[-1].strip }
      puts upload
      puts download
      puts total
      puts expired_time

      update(
        upload_used: upload.to_i,
        download_used: download.to_i,
        total_bandwidth: total.to_i,
        expired_at: expired_time.present? ? Time.at(expired_time.to_i) : nil
      )
    end
  end
end
