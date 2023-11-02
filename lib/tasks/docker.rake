namespace :docker do
  task :build do
    system(%Q[
      docker buildx build \
        --secret id=master_key,src=config/master.key \
        --secret id=credentials_data,src=config/credentials.yml.enc \
        -t subway:dev .
    ])
  end

  namespace :compose do
    task :run do
      system(%Q[docker compose up])
    end
  end

  task :run do
    system(%Q[
      docker run --rm --name subway-dev -p 3003:3000 \
      -e DATABASE_URL=postgresql://postgres:postgres@localhost:postgres \
      -e RAILS_MASTER_KEY=#{File.read(Rails.root.join("config/master.key"))} \
      -v #{Rails.root.join("config/credentials.yml.enc")}:/app/config/credentials subway:dev
    ])
  end
end
