# frozen_string_literal: true

Darjeelink::Engine.routes.draw do
  root 'short_links#index'

  resources :short_links
  resources :tracking_links, only: :new
  resources :api, only: :create

  # OmniAuth
  get '/auth/:provider/callback', to: 'sessions#create'
  post '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: 'application#auth_failure'
end
