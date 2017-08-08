Rails.application.routes.draw do
  devise_for :employees
  authenticate :employee do
    mount Admin::Engine => "/admin"
  end
end
