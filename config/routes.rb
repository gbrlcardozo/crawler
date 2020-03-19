Rails.application.routes.draw do
  resources :cultures
  get 'cultures/:id' => "shortener/shortened_urls#show"
  # root 'cultures#cultures'

  resources :socials
  get 'socials/:id' => "shortener/shortened_urls#show"

  resources :crawlers
  get 'crawlers/:id' => "shortener/shortened_urls#show"
  root 'crawlers#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
