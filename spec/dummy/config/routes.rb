# frozen_string_literal: true

Rails.application.routes.draw do
  mount Darjeelink::Engine => '/'

  # Go to short links
  get '/:id' => 'darjeelink/short_links#show'
end
