Admin::Engine.routes.draw do
  resources :employees
  root to: 'menu#index'
end
