Rails.application.routes.draw do
  get 'sessions/new'

  get 'sessions/create'

  get 'sessions/failure'

  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :challenges

  resources :openchallenges

  resources :votes

  resources :evidences

  root 'challenges#index'

  get '/users/:id', to: 'users#show', as: 'user'

  get '/users/:id/edit', to: 'users#edit', as: 'user_edit'

  get '/users/:id/victories', to: 'users#victories', as: 'user_victories'

  get '/users/:id/defeats', to: 'users#defeats', as: 'user_defeats'

  get '/users/:id/declined', to: 'users#declined', as: 'user_declined'

  patch '/users/:id/', to: 'users#update'

  post '/challenge/:id/declined', to: 'user_mailer#decline'

  get '/in_progress_end', to: 'challenges#in_progress_end'

  get '/voting_end', to: 'votes#voting_end', :as => :voting_end
  
  get '/open_voting_end', to: 'votes#open_voting_end', :as => :open_voting_end

  post '/openchallenges/create' => 'openchallenges#create', :as => :create_openchallenge

  post '/evidences/open_create' => 'evidences#open_create', :as => :create_openevidence

  post '/evidences/open_new' => 'evidences#open_new', :as => :new_openevidence

  post '/votes/open_vote' => 'votes#open_vote', :as => :open_vote

  post '/votes/vote_boost' => 'votes#vote_boost', :as => :vote_boost

  post '/openchallenges/:id/sort_new' => 'openchallenges#sort_new', :as => :sort_new
  post '/openchallenges/:id/sort_votes' => 'openchallenges#sort_votes', :as => :sort_votes


  get '/trophies' => 'users#trophies', :as => :trophies




  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
