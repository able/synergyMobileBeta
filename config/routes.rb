SynergyMobileBeta::Application.routes.draw do
  match 'rest/actuation/:uri/methods/:method' => 'rest#actuation', :constraints => {:uri => /.*/, :method => /.*/}


  match 'rest/subtypes/spaces' => 'rest#all_space_subtypes'
  match 'rest/subtypes/things' => 'rest#all_thing_subtypes'

  match 'rest/users/sign_up' => "rest#sign_up"
  match 'rest/users/all' => "rest#list_all_users"

  match 'rest/liveSynergy/:uri/add' => 'rest#add_existing_entity', :constraints => {:uri => /.*/}
  match 'rest/liveSynergy/:uri/delete' => "rest#delete_entity", :constraints => {:uri => /.*/}
  match 'rest/:uri/things/public' => "rest#my_public_things", :constraints => {:uri => /.*/}
  match 'rest/:uri/things/private' => "rest#my_private_things", :constraints => {:uri => /.*/}
  match 'rest/:uri/things/all' => "rest#my_things", :constraints => {:uri => /.*/}

  match 'rest/:uri/spaces/public' => "rest#my_public_spaces", :constraints => {:uri => /.*/}
  match 'rest/:uri/spaces/private' => "rest#my_private_spaces", :constraints => {:uri => /.*/}
  match 'rest/:uri/spaces/all' => "rest#my_spaces", :constraints => {:uri => /.*/}

  match 'rest/spaces/public/all' => "rest#all_public_spaces"
  match 'rest/things/public/all' => "rest#all_public_things"


  match 'rest/test' => "rest#test"
  match 'rest/entities/create' => "rest#create_new_entity"
  match 'rest/triggers/create' => "rest#create_new_trigger"

  match 'rest/friends/all' => "rest#view_my_friends"

  match 'rest/liveSynergy/:uri' => 'rest#view', :constraints => {:uri => /.*/}


  # match '/settings' => "triggers#onHumanEnter_index", :constraints => {:uri => /.*/}
  match '/allfriends' => "friends#allfriends"
  match 'liveSynergy/:uri/add_livePulse' => "entities#add_livePulse", :constraints => {:uri => /.*/}, :via => :get
  match 'liveSynergy/:uri/add_livePulse' => "entities#create_livePulse", :constraints => {:uri => /.*/}, :via => :post

  match '/users/:uri/energy/hour/data' => "energy#user_hour_data", :constraints => {:uri => /.*/}
  match '/users/:uri/energy/hour' => "energy#userhour", :constraints => {:uri => /.*/}
  match '/:uri/energy/hour/data' => "energy#hour_data", :constraints => {:uri => /.*/}
  match '/userview/:uri' => "friends#view", :constraints => {:uri => /.*/}
  match '/:uri/energy/hour' => "energy#hour", :constraints => {:uri => /.*/}

  match 'liveSynergy/:uri/methods/turnOn' => "triggers#turned_on_dialog", :constraints => {:uri => /.*/}
  match 'sms/sent' => "triggers#sms_sent_dialog"
  match 'liveSynergy/msra/sms-gateway/methods/send' => "triggers#send_sms_index", :via => :get
  match 'liveSynergy/msra/sms-gateway/methods/send' => "triggers#send_sms", :via => :post
  match '/failure/actuation' => "triggers#failure_dialog", :constraints => {:uri => /.*/}
  match 'liveSynergy/:uri/methods/turnOff' => "triggers#turned_off_dialog", :constraints => {:uri => /.*/}
  match 'liveSynergy/:uri/events/whenNumOccupancyReachesX' => "triggers#whenNumOccupancyReachesX_index", :constraints => {:uri => /.*/}
  match 'liveSynergy/:uri/events/onHumanEnter' => "triggers#onHumanEnter_index", :constraints => {:uri => /.*/}
  match 'liveSynergy/:uri/events/onHumanExit' => "triggers#onHumanExit_index", :constraints => {:uri => /.*/}
  match 'liveSynergy/:uri/methods/currentOccupancy' => "triggers#currentOccupancy", :constraints => {:uri => /.*/}
  match 'liveSynergy/:uri' => "entities#view", :constraints => {:uri => /.*/}
  match 'add/:uri' => "entities#view_added_dialog", :constraints => {:uri => /.*/}
  match 'addedThing' => "entities#view_added_new_thing_dialog"
  match 'addedSpace' => "entities#view_added_new_space_dialog"
  match 'friends/add/:uri' => "friends#view_added_dialog", :constraints => {:uri => /.*/}
  match 'friends/delete/:uri' => "friends#view_delete_dialog", :constraints => {:uri => /.*/}
  match 'deletefriend/:uri' => "friends#delete_friend", :constraints => {:uri => /.*/}, :via => :get
  match 'delete/:uri' => "entities#view_delete_dialog", :constraints => {:uri => /.*/}, :via => :get
  match 'triggers/delete/:id' => "triggers#view_delete_dialog", :constraints => {:id => /.*/}, :via => :get

  match 'triggers/add/:uri/events/whenNumOccupancyReachesX' => "triggers#whenNumOccupancyReachesX_add_trigger", :constraints => {:uri => /.*/}, :via => :get
  match 'triggers/add/:uri/events/onHumanEnter' => "triggers#onHumanEnter_add_trigger", :constraints => {:uri => /.*/}, :via => :get
  match 'triggers/add/:uri/events/onHumanEnter' => "triggers#onHumanEnter_create_trigger", :constraints => {:uri => /.*/}, :via =>:post
  match 'triggers/add/:uri/events/onHumanExit' => "triggers#onHumanExit_add_trigger", :constraints => {:uri => /.*/}, :via => :get
  match 'triggers/add/:uri/events/onHumanExit' => "triggers#onHumanExit_create_trigger", :constraints => {:uri => /.*/}, :via => :post
  match 'triggers/add/:uri/events/whenNumOccupancyReachesX' => "triggers#whenNumOccupancyReachesX_create_trigger", :constraints => {:uri => /.*/}, :via => :post

  match 'triggers/add/msra/sms-gateway/methods/send' => "triggers#send_sms_add_trigger", :via => :get
  match 'triggers/add/msra/sms-gateway/methods/send' => "triggers#send_sms_add_trigger_finalize", :via => :post


  match 'delete/:uri' => "entities#delete_entity", :constraints => {:uri => /.*/}, :via => :delete

  match 'triggers/show/:id' => 'triggers#show', :via => :get
  match 'triggers/edit/:id' => 'triggers#edit', :via => :get
  match 'triggers/edit/:id' => 'triggers#update', :via => :post
  match 'triggers/added' => "triggers#view_added_dialog"
  
  match 'add_friend' => 'friends#add_existing_friend', :via => :get
  match 'add_friend' => 'friends#create_existing_friend', :via => :post
  match 'friends' => 'friends#view_all_friends', :via => :get

  match 'add_thing' => 'entities#add_new_or_existing_thing_dialog', :via => :get
  match 'new_thing' => 'entities#new_thing', :via => :get
  match 'new_space' => 'entities#new_space', :via => :get
  match 'choose_containing_space' => 'entities#choose_containing_space', :via => :get
  match 'add_space' => 'entities#add_new_or_existing_space_dialog', :via => :get
  match 'entities/add_existing_thing' => 'entities#create_existing_thing', :via => :post
  match 'entities/add_existing_thing' => 'entities#add_existing_thing', :via => :get

  match 'entities/add_existing_space' => 'entities#create_existing_space', :via => :post
  match '/new_thing_created' => 'entities#new_thing_created', :via => :post
  match '/new_space_created' => 'entities#new_space_created', :via => :post
  match 'entities/add_existing_space' => 'entities#add_existing_space', :via => :get  
  
  #match 'entities/add_new_thing' => 'entities#add_new_thing', :via => :get
  match 'entities/add_new_thing' => 'entities#new_thing', :via => :get
  match 'entities/add_new_thing' => 'entities#create_new_thing', :via => :post
  
  #match 'entities/add_new_space' => 'entities#add_new_space', :via => :get
  match 'entities/add_new_space' => 'entities#new_space', :via => :get
  match 'entities/add_new_space' => 'entities#create_new_space', :via => :post
  
  match 'triggers/add' => 'triggers#add_new_trigger', :via => :get
  match 'triggers/add' => 'triggers#create_new_trigger', :via => :post
  

  match 'things/all' => 'entities#list_all_things', :via => :get
  match 'things/public' => 'entities#public_things', :via => :get
  match 'things/private' => 'entities#private_things', :via => :get
  match 'spaces/all' => 'entities#list_all_spaces', :via => :get
  match 'spaces/public' => 'entities#public_spaces', :via => :get
  match 'spaces/private' => 'entities#private_spaces', :via => :get
 #  match 'entities/list_all_spaces' => 'entities#list_all_spaces', :via => :get
  match 'triggers/all' => 'triggers#index', :via => :get

  match 'entities/edit_thing/:id' => 'entities#edit_thing', :via => :get
  match 'entities/edit_space/:id' => 'entities#edit_space', :via => :get

 
  match 'entities/update_form_add_new_trigger' => 'entities#update_form_add_new_trigger'
  
  match 'map/coordinates' => 'map#coordinates'
  match 'friends/coordinates' => 'map#friends_coordinates'

  match 'entities/energy_things_spaces_friends_menu' => 'entities#energy_things_spaces_friends_menu'
  match 'energy/thing/:url' => 'energy#thing_energy'
  
  match 'map' => 'map#index'
  match 'map2' => 'map#index5'
  
  match 'energy/thing2/:url' => 'energy#thing_energy2'
  match 'energy/thing3/:url' => 'energy#thing_energy3'
 
  match 'energy/thing4/:url' => 'energy#thing_energy4'
  match 'energy/thing5/:url' => 'energy#thing_energy5'
  
  match 'home/menu' => 'home#menu', :via => :get
   
  # match 'entities/index_spaces' => 'entities#index_spaces', :via => :get
  # match 'entities/index_things' => 'entities#index_things', :via => :get
  # 
  # match 'entities/show_space/:id' => 'entities#show_space', :via => :get
  # match 'entities/show_thing/:id' => 'entities#show_thing', :via => :get
  # 


  # devise_for :users
  
  # devise_for :users, :controllers => { :registrations => "users/registrations" } do
  #   get '/users/sign_up', :to => 'users/registrations#new'  
  # end
  
  devise_for :users, :stateless_token => true, :controllers => {:sessions => "sessions", :registrations => "registrations"} do
    match '/users/sign_up', :to => 'registrations#new'
    # match '/users/sign_in', :to => 'sessions#new', :via => :get
    # match '/users/sign_in', :to => 'sessions#create', :via => :post

    match '/users/sign_up/:liveLinkID', :to => 'registrations#new_liveLinkID'
  end

  

  root :to => "home#index"
  
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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
