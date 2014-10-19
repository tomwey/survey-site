SurveySite::Application.routes.draw do
  devise_for :users, :path => "account", :controllers => {
    :sessions => :sessions
  }

  resources :surveys
  
  root to: 'surveys#index'
end
