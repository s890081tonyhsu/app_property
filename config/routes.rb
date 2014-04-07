AppProperty::Application.routes.draw do
  resources :contacts, only: [:new, :create]
  resources :visitors, only: [:new, :create]
  root to: 'visitors#new'
  get "item" => "item#view_item"
  get "item/view" => "item#view_item"
  get "item/new" => "item#new_item"
  get "item/modify_item/:id" => "item#modify_item"
  get "item/delete_item/:id" => "item#delete_item"

  post "item/create_item" => "item#create_item"
  post "item/update_item/:id" => "item#update_item"
  get "item/:id" => "item#show_item"
  put "item/update_item/:id" => "item#update_item"
  put "item/delete_item/:id" => "item#delete_item"
end
