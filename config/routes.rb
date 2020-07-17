Rails.application.routes.draw do
	get 'home' => 'static_pages#about'
	get 'process_ajax' => 'static_pages#process_ajax'
	match 'about', to: 'static_pages#about', via: :get

  devise_for :users, defaults: {format: :html}
  devise_scope :user do
	  get '/login', to: 'devise/sessions#new', defaults: {format: :html}
		post '/login', to: 'devise/sessions#create', defaults: {format: :html}
		delete '/logout', to: 'devise/sessions#destroy', defaults: {format: :html}
	end

  resources :tasks, defaults: {format: :html}
  resources :projects, defaults: {format: :html} do
  	  resources :tasks, defaults: {format: :html}, parent: 'Project'
  end




  root	'static_pages#about'
end
