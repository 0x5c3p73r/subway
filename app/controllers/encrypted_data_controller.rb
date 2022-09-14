class EncryptedDataController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create

  def index
  end

  def create
    env_key = "ONSHOT_MASTER_KEY"

    ENV[env_key] = ActiveSupport::EncryptedConfiguration.generate_key

    generator = ActiveSupport::EncryptedConfiguration.new(
      config_path: '',
      key_path: '',
      env_key: env_key,
      raise_if_missing_key: false
    )

    master_key = generator.key
    contents = {
      'secret_key_base' => SecureRandom.alphanumeric(64),
      'active_record_encryption' => {
        'primary_key' => SecureRandom.alphanumeric(32),
        'deterministic_key' => SecureRandom.alphanumeric(32),
        'key_derivation_salt' => SecureRandom.alphanumeric(32),
      }
    }
    encrypted_data = generator.send(:encrypt, YAML.dump(contents))

    ENV.delete(env_key)
    render json: {
      master_key: master_key,
      encrypted_data: encrypted_data,
      contents: contents
    }
  end
end
