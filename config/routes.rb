Rails.application.routes.draw do
  root 'welcome#index'
  get 'review_code' => 'welcome#review_code', as: :review_code_get
  post 'review_code' => 'welcome#review_code', as: :review_code
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
