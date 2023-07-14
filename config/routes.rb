Rails.application.routes.draw do
  resources :dogs, only: [] do
    resources :counted_behavior_occurrences, only: [:index, :create]
    resources :counted_behaviors, only: [] do
      scope module: :counted_behaviors do
        resources :counted_behavior_occurrences, path: :occurrences, only: [:index] do
          collection do
            patch :update_count
            delete :destroy_latest
          end
        end
      end
    end
    # TODO: data visualization
  end

  root to: redirect("/dogs/1/counted_behavior_occurrences")
end
