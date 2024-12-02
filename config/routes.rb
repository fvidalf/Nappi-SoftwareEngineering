Rails.application.routes.draw do
  devise_for :users, controllers: {sessions: 'users/sessions', registrations: 'users/registrations'},
              path: '', path_names: {sign_in: 'login', sign_out: 'logout', sign_up: 'register'} 
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get '/', to:'home#index'
  # Helpers para rutas de los distintos modelos
  resources :requests, :products, :p_requests, :reviews
  resources :users do
    resources :requests
  end
  resources :chats do
    resources :messages
  end
  # Ruta del carrito
  get "users/:user_id/carrito", to:"requests#show_cart", as: "user_cart"
  get "users/:user_id/delete_cart/:request_id", to: "requests#destroy_from_cart", as: "destroy_cart_request"
  get "users/:user_id/carrito/send_request", to: "requests#update_status", as: "send_request"
  patch "users/:user_id/carrito/p_requests", to: "p_requests#update", as: "update_p_request"
  patch "users/:user_id/carrito/send_p_requests", to: "p_requests#update_status", as: "send_p_requests"

  # Product review
  get "reviews/product/new", to: "reviews#new_product_review", as: "new_product_review"

  # Chat user-admin
  get "users/:user_id/chats", to: "chats#index", as: "index_chats"  # Index de chats
  get "users/:user_id/chats/:admin_id", to: "chats#show", as: "show_chat"  # Chat individual
  post "users/:user_id/chats/:admin_id", to: "chats#create", as: "create_user_chat"
  delete "users/:user_id/chats/delete/:chat_id", to: "chats#destroy", as: "delete_chat"

  # PRequests del administrador
  get "users/:user_id/p_requests", to: "p_requests#admin_index", as: "admin_p_requests"
  patch "users/:user_id/p_requests/:p_request_id", to: "p_requests#admin_update", as: "p_request_resolution"

  # Notificaciones
  get "users/:user_id/notifications", to: "notifications#index", as: "notifications"
  patch "users/:user_id/read_notification/:id", to: "notifications#update_read_status", as: "read_notification"
end
