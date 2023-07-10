Rails.application.routes.draw do
  resources :dogs, only: [] do
    resources :tracked_behaviors, only: [:index, :create]
    resources :behaviors, only: [] do
      scope module: :behaviors do
        resources :tracked_behaviors, only: [:index] do
          collection do
            patch :update_count
            delete :destroy_latest
          end
        end
      end
    end
    # TODO: data visualization
  end

  root to: redirect("/dogs/1/tracked_behaviors")
end
