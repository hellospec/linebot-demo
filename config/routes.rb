Rails.application.routes.draw do
  devise_for :users, skip: [:registrations], path: "authen", controllers: {
    sessions: "users/sessions"
  }

  namespace :admin do
    get "/", to: "admin_panel#show"

    resources :sale_persons
    resources :sale_person_invitations
    resources :products
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check
  resources :linebot

  resources :fake_inputs
  resources :sale_orders
  resource :dashboard


  authenticated :user, -> (u) { u.admin? } do
    root to: "admin/admin_panel#show", as: :authenticated_admin
  end
  root "dashboard#show"
end
