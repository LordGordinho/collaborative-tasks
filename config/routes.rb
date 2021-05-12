Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'
  resources :tasks
  resources :lists
  get 'lists/:id/get_all_tasks_on_list' ,to: 'lists#get_all_tasks_on_list'
  get 'lists/:id/get_all_users_of_list' ,to: 'lists#get_all_users_of_list'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
