Rails.application.routes.draw do

  root 'pages#home'

  get 'help' => 'pages#help'
  get 'about' => 'pages#about'

  resources :users, only: [:new, :create], path_names: { new: 'signup' }

  get 'stats' => 'stats#show'
  get 'sample' => 'stats#sample'
  get 'shared/:user' => 'stats#shared', as: :shared

  get 'stats/topic/:topic' => 'stats#topic', as: :topic
  get 'sample/topic/:topic' => 'stats#sample_topic', as: :sample_topic
  get 'shared/:user/topic/:topic' => 'stats#shared_topic', as: :shared_topic

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  resources :sessions, only: [:new, :create, :destroy],
    path_names: { new: 'login' }

  resources :password_resets, only: [:new, :create, :edit, :update],
    path_names: { new: 'forgot', edit: 'reset' }

  get 'game' => 'games#game', as: :game
  delete 'delete/:game_id' => 'games#destroy', as: :delete

  get 'backup/:backup_id/download' => 'backups#download'

  # Allow only Ajax requests to the following routes:
  constraints(->(req) { req.xhr? }) do
    get 'json/:game_id' => 'games#json', as: :json
    post 'save' => 'games#save', as: :save
    patch 'redate' => 'games#redate', as: :redate
    get 'check/:final_id' => 'games#check', as: :check

    patch 'filters' => 'users#update_user_filters'
    patch 'sharing' => 'users#update_sharing_status'

    get 'stats/games' => 'stats#games', as: :games
    get 'sample/games' => 'stats#sample_games', as: :sample_games
    get 'shared/:user/games' => 'stats#shared_games', as: :shared_games

    get 'backup' => 'backups#new'
    get 'backup/:backup_id' => 'backups#status'
    post 'restore' => 'backups#restore'
    get 'restore/:restore_id' => 'backups#restore_progress'
  end
end
