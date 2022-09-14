Rails.application.routes.draw do
  resources :coaches do
    resources :subscribes, only: %i[ edit update :destroy ]
    resources :configs, only: %i[ edit update :destroy ]
    resources :backends, only: %i[ edit update :destroy ]
  end

  # Subscribe short url 010497e7-95c0-4655-bcd0-2714168d4ba4
  get "/:id", to: "shorts#show", id: /(\w{4,}-*){5}/, as: :short

  if ENV["ENABLE_TOOLS_API"] == "true" || Rails.env.development?
    scope :tools do
      resources :encrypted_data, only: %i[ index create ]
    end
  end

  # mount GoodJob::Engine => 'good_job'

  root "coaches#new"
end
