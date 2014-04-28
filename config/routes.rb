AppProperty::Application.routes.draw do
  root to: 'main#index'
  get 'about' => 'main#about'
  get 'introduction' => 'main#introduction'

  # Item CRUD
  get "item" => "item#view_item"
  get "item/view" => "item#view_item"
  get "item/new" => "item#new_item"
  get "item/manage" => "item#manage_item"
  get "item/:id" => "item#show_item"
  get "item/modify_item/:id" => "item#modify_item"
  get "item/delete_item/:id" => "item#delete_item"

  post "item/create_item" => "item#create_item"
  patch "item/update_item/:id" => "item#update_item"
  put "item/update_item/:id" => "item#update_item"
  put "item/delete_item/:id" => "item#delete_item"

  # Lend CRUD
  get "lend" => "lend#view_lend"
  get "lend/view" => "lend#view_lend"
  get "lend/new" => "lend#new_lend"
  get "lend/new/:id" => "lend#new_lend"
  get "lend/verify" => "lend#verify"
  post "lend/verify" => "lend#verify"
  get "lend/audit" => "lend#audit"
  post "lend/audit" => "lend#audit"
  get "lend/:id" => "lend#show_lend"
  get "lend/modify_lend/:id" => "lend#modify_lend"
  get "lend/delete_lend/:id" => "lend#delete_lend"

  post "lend/create_lend" => "lend#create_lend"
  patch "lend/update_lend/:id" => "lend#update_lend"
  put "lend/update_lend/:id" => "lend#update_lend"
  put "lend/delete_lend/:id" => "lend#delete_lend"

end
