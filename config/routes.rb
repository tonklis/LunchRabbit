LunchRabbit::Application.routes.draw do
  get "register", :to => 'display#register', :as => :register

  get "index", :to => 'display#index'

  get "home(/:limit)", :to => 'display#home', :as => :home

  get "help", :to => 'display#help', :as => :help

  match 'myprofile', :to => 'display#myprofile', :as => :myprofile
  
  match 'profile/:id', :to => 'display#profile', :as => :profile

  get 'logout', :to => 'display#logout', :as => :logout 
  
  get 'intereses/busqueda', :to => 'intereses#busqueda', :as => :busqueda_intereses

  get 'items', :to => 'items#busqueda', :as => :busqueda_items

  resources :invitaciones

  resources :intereses

  resources :grupos

  resources :zonas

  resources :usuarios
  
  devise_for :usuarios, :controllers => { :omniauth_callbacks => "usuarios/omniauth_callbacks"}

  match 'usuarios/encuentra_o_crea/:id' => 'usuarios#encuentra_o_crea'

  match 'usuarios/busqueda/:id' => 'usuarios#busqueda', :as => :busqueda_usuarios
  
  match 'usuarios/busqueda_por_interes/:id' => 'usuarios#busqueda_por_interes', :as => :busqueda_usuarios_por_interes

  match 'usuarios/actualiza/:id', :to => 'usuarios#actualiza', :as => :actualiza

  match 'invitaciones/por_usuario/:id' => 'invitaciones#por_usuario'

  match 'invitaciones/desde_para/:id' => 'invitaciones#desde_para', :as => :desde_para_invitaciones

  match 'invitaciones/acepta/:id' => 'invitaciones#acepta'

  match 'invitaciones/rechaza/:id' => 'invitaciones#rechaza'

  match 'invitaciones/muestra_todas/:id' => 'invitaciones#muestra_todas', :as => :muestra_invitaciones

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => "display#index"
  # root :to => "oauth#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
