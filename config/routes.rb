Rails.application.routes.draw do
  resources :dogs, only: [] do
    resources :tracked_behaviors, only: [:index, :create]
    # TODO: data visualization
  end

  root to: redirect("/dogs/1/tracked_behaviors")
end
