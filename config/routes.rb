AppProperty::Application.routes.draw do
  resources :contacts, only: [:new, :create]
  resources :visitors, only: [:new, :create]
  root to: 'visitors#new'
  get "item" => "item#view_item"
  get "item/view" => "item#view_item"
end
