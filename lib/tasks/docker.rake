namespace :docker do
  task :build do
    system(%Q[docker buildx build --secret id=master_key,src=config/master.key -t subway:dev .])
  end

  namespace :compose do
    task :run do
      system(%Q[docker compose up])
    end
  end

  task :run do
    system(%Q[
      docker run --rm --name subway-dev -p 3001:3000 \
      -e RAILS_MASTER_KEY=13e13a779b26105254e2e3e2df91f348 \
      -v #{Rails.root.join("config/credentials")}:/app/config/credentials subway:dev
    ])
  end
end
