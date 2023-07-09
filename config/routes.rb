Rails.application.routes.draw do
  resources :dogs, only: [] do
    resources :tracked_behaviors, only: [:index, :create]
  end

  root to: redirect("/dogs/1/tracked_behaviors")
end
