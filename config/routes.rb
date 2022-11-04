Rails.application.routes.draw do
  # Subscribe short url 010497e7-95c0-4655-bcd0-2714168d4ba4
  get "/:id", to: "shorts#show", id: /(\w{4,}-*){5}/, as: :short

  scope "(:locale)"  do
    root "coaches#index", as: :locale_root

    resources :coaches do
      collection do
        get :verify_ticket
      end

      resources :subscribes, only: %i[ edit update destroy ]
      resources :configs, only: %i[ edit update destroy ]
      resources :backends, only: %i[ edit update destroy ]
    end

    if ENV["ENABLE_TOOLS_API"] == "true" || Rails.env.development?
      scope :tools do
        resources :encrypted_data, only: %i[ index create ]
      end
    end
  end

  if ENV["ENABLE_DASHBOARD"] == "true" || Rails.env.development?
    mount GoodJob::Engine => "dashboard"
  end

  root "coaches#new"
end
