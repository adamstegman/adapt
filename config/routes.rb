Rails.application.routes.draw do
  resources :dogs, only: [] do
    resources :behaviors, only: [:index] do
      scope module: :behaviors do
        resources :behavior_occurrences, path: :occurrences, only: [:index, :create, :update]
      end
    end
  end

  get "about/index"

  root to: redirect("/dogs/1/behaviors")
end
