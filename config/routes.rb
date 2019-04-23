Rails.application.routes.draw do
	resources :menus do 
		collection do 
			get :pundit_groups
		end
	end
	
  resources :roles do 
    collection do 
    end
  	member do 
  		get :menus
      get :pundit_groups
      post :save_menus
      post :save_pundit_groups
  	end
  end

  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
