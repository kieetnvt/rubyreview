Rails.application.routes.draw do
  root 'review#index'
  get 'review' => 'review#review_code', as: :get_review
  post 'review' => 'review#review_code', as: :review
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
