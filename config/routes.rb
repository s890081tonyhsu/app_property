AppProperty::Application.routes.draw do
  resources :contacts, only: [:new, :create]
  resources :visitors, only: [:new, :create]
  root to: 'visitors#new'
  get "item" => "item#view_item"
  get "item/view" => "item#view_item"
  get "item/new" => "item#new_item"
  get "item/modify/:id" => "item#modify"
  get "item/del/:id" => "item#del"

  post "item/create_item"
  get "item/:id" => "item#show_item"
  put "item/updating/:id" => "item#updating"
  put "item/destroying/:id" => "item#destroying"
end
