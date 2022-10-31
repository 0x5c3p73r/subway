class Coach < ApplicationRecord
  include Encryptor
  include HttpRequest

  TARGETS = {
    clash: "Clash",
    clashr: "ClashR",
    quan: "Quantumult",
    quanx: "Quantumult X",
    loon: "Loon",
    ss: "SS (SIP002)",
    ssshub: "SS Android",
    ssd: "SSD",
    ssr: "SSR",
    surboard: "Surfboard",
    surgev2: "Surge v2",
    surgev3: "Surge v3",
    surgev4: "Surge v4",
    v2ray: "V2Ray",
  }

  has_many :coach_backends
  has_many :backends, through: :coach_backends

  has_many :coach_configs
  has_many :configs, through: :coach_configs

  has_many :coach_subscribes
  has_many :subscribes, through: :coach_subscribes

  encrypts :name
  encrypts :description
  enum target: TARGETS.keys

  validates :subscribes, presence: true

  after_create :generate_name
  after_create :generate_encrypt_value

  before_destroy :destroy_relationship_data

  def backend
    coach_backends.find_by(enabled: true).backend
  end

  def config
    coach_configs.find_by(enabled: true)&.config
  end

  def avaiable_configs
    Config.all_system.to_a.concat(coach_configs.all.map(&:config)).uniq
  end

  def avaiable_backends
    Backend.all_system.to_a.concat(coach_backends.all.map(&:backend)).uniq
  end

  def add_config(config)
    exist_config = coach_configs.find_by(config_id: config.id)
    return if exist_config && exist_config.enabled

    # Delete previouse enabled system configs
    clear_enabled_system_configs!

    # Disable all customer configs
    coach_configs.update_all(enabled: false)

    if exist_config && !exist_config.enabled
      return exist_config.update(enabled: true)
    end

    # Update new config
    coach_configs.create(config: config, enabled: true)
  end

  def add_backend(backend)
    exist_backend = coach_backends.find_by(backend_id: backend.id)
    return if exist_backend && exist_backend.enabled

    # Delete previouse enabled system backends
    clear_enabled_system_backends!

    # Disable all customer backends
    coach_backends.update_all(enabled: false)

    if exist_backend && !exist_backend.enabled
      return exist_backend.update(enabled: true)
    end

    # Update new backend
    coach_backends.create(backend: backend, enabled: true)
  end

  def clear_enabled_system_backends!
    coach_backends.each do |cb|
      cb.destroy if cb.backend.source == "system"
    end
  end

  def clear_enabled_system_configs!
    coach_configs.each do |cc|
      cc.destroy if cc.config.source == "system"
    end
  end

  def encrypt_matches?(private_key)
    _encrypt(private_key) == encrypt_value
  end

  def subconverter_url(overwrite_params = {})
    new_target = overwrite_params.delete(:target) || target

    uri = URI.parse(backend.subconverter_url)
    query = target_params(new_target)
    query[:new_field_name] = true if query[:target] == "clash" # Nobody use legacy clash version?
    query[:url] = subscribes_urls
    query[:config] = config.link if config
    query[:filename] = id
    query.merge!(overwrite_params)

    uri.query = URI.encode_www_form(query)
    uri.to_s
  end

  def fetch_content(overwrite_params = {})
    logger.info "Fetching content for backend by id: #{id}"
    res = fetch(subconverter_url(overwrite_params))
    raise Faraday::Error, "Can not request content from backend" unless res.success?

    res.body
  end

  def ticket_key
    @ticket_key ||="subway-ticket-#{self.id}"
  end

  private

  def target_params(new_target)
    return { target: new_target } unless new_target.start_with?("surgev")

    surge_version = new_target[-2..-1]
    {
      target: "surge",
      ver: surge_version
    }
  end

  def subscribes_urls
    subscribes.select(:link).map(&:link).join("|")
  end

  def generate_name
    return if name.present?

    update_column(:name, "No. #{id} Coache")
  end

  def destroy_relationship_data
    coach_subscribes.each do |cs|
      cs.destroy
      cs.subscribe.destroy
    end

    coach_configs.each do |cc|
      cc.destroy
      cc.config.destroy
    end

    coach_backends.each do |cb|
      cb.destroy
      cb.backend.destroy
    end
  end

  def destroy_subscribes
    subscribes.destroy_all
  end

  def destroy_configs
    configs.where(source: :customer).destroy_all
  end

  def generate_encrypt_value
    private_key = "sad_#{generate_key(salt: SecureRandom.uuid, length: 24)}"
    Rails.cache.write(ticket_key, private_key, expires_in: 1.minute)

    update_column(:encrypt_value, _encrypt(private_key))
  end

  def _encrypt(private_key)
    encrypt(created_at.to_i.to_s, private_key)
  end
end
