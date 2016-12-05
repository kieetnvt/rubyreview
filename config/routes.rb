Rails.application.routes.draw do
  root 'welcome#index'
  get 'review' => 'welcome#review_code', as: :get_review
  post 'review' => 'welcome#review_code', as: :review
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
