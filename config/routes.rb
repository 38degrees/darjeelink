# frozen_string_literal: true

Darjeelink::Engine.routes.draw do
  root 'short_links#index'

  resources :short_links
  resources :tracking_links, only: :new

  # OmniAuth
  get '/auth/:provider/callback', to: 'sessions#create'
end
