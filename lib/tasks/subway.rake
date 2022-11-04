namespace :subway do
  task upgrade: :environment do
    db_version = ActiveRecord::Migrator.current_version
    if db_version.blank? || db_version.zero?
      Rake::Task['db:setup'].invoke # need db/schema.rb
      Rake::Task['db:migrate:status'].invoke
    else
      Rake::Task['db:migrate'].invoke
    end
    Rake::Task['db:seed'].invoke
  end

  task :credentials do
    if Rails.env.development?
      encrypted_file_path = Rails.root.join('config', 'credentials.yml.enc')

      require "rails/generators/rails/master_key/master_key_generator"
      master_key_generator = Rails::Generators::MasterKeyGenerator.new([], quiet: true, force: false)
      master_key_generator.add_master_key_file_silently
      master_key_generator.ignore_master_key_file_silently

      require "rails/generators/rails/credentials/credentials_generator"
      Rails::Generators::CredentialsGenerator.new([], quiet: true).add_credentials_file
    else
      master_key_path = Rails.root.join('config', 'credentials', 'production.key')
      encrypted_file_path = Rails.root.join('config', 'credentials', 'production.yml.enc')
      encrypted_data = ENV['RAILS_ENCRYPTED_DATA'].presence
      if encrypted_data && (!File.exist?(encrypted_file_path) || File.read(encrypted_file_path).empty?)
        puts "Write encrypted data into #{encrypted_file_path}"
        File.write(encrypted_file_path, ENV['RAILS_ENCRYPTED_DATA'])
      end
    end

    encrypted = Rails.application.encrypted(encrypted_file_path)
    if encrypted.key.nil?
      fail [
        "Missing `RAILS_MASTER_KEY` enviroment value and not found file in #{master_key_path}.",
        "Make sure generate one first and store it in a safe place."
      ].join("\n")
    end

    next if encrypted_data

    begin
      raw_data = File.empty?(encrypted_file_path) ? {} : (YAML.load(encrypted.read) || {})
      puts "Preparing encrypted keys: secret_key_base, active_record_encryption ..."

      # Priority: environment > rails builtin > credentials.yml.enc raw data
      raw_data['secret_key_base'] = ENV['SECRET_TOKEN'].presence || raw_data['secret_key_base'] || SecureRandom.alphanumeric(32)

      # Support encrypted_key in model
      raw_data['active_record_encryption'] = {
        'primary_key' => SecureRandom.alphanumeric(32),
        'deterministic_key' => SecureRandom.alphanumeric(32),
        'key_derivation_salt' => SecureRandom.alphanumeric(32),
      }

      Rails.application.encrypted(encrypted_file_path).write(YAML.dump(raw_data))
    rescue OpenSSL::Cipher::CipherError, ActiveSupport::MessageEncryptor::InvalidMessage
      puts "Couldn't decrypt #{encrypted_file_path}. Perhaps `RAILS_MASTER_KEY` enviroment value is incorrect?"
    end
  end
end
