Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  controller :home do 
    get '/' => :index, :as => :root    
    get '/privacy' => :privacy, :as => :privacy
    get '/about' => :about, :as => :about
    get '/faq' => :about, :as => :faq
    get '/donate' => :about, :as => :donate
    get '/guidelines' => :guidelines, :as => :guidelines
    get '/welcome' => :welcome, :as => :welcome
    get '/lists' => :lists, :as => :lists
  end

  controller :post do
    get '/post' => :new, :as => :new_post
    put '/update_post/:id' => :update, :as => :update_post
    get '/post/:url_title' => :show, :as => :post
    post '/post' => :create, :as => :create_post
    get '/edit_post/:id' => :edit, :as => :edit_post
    get '/upvote/:id' => :upvote, :as => :upvote_post    
    get '/flag_post/:id' => :flag, :as => :flag_post
    get '/favorite_post/:id' => :favorite, :as => :favorite_post
    delete '/post/:id' => :delete, :as => :delete_post
  end

  controller :comments do
    get '/comments' => :index, :as => :comments
    get '/comment_parent/:id' => :parent, :as => :comment_parent
    get '/comment/:id' => :show, :as => :comment
    get '/edit_comment/:id' => :edit, :as => :edit_comment
    post '/comment/:post_id/:comment_id' => :create, :as => :create_comment
    put '/comment/:comment_id' => :update, :as => :update_comment    
    get '/upvote_comment/:id' => :upvote, :as => :upvote_comment
    delete '/delete_comment/:id' => :destroy, :as => :delete_comment
  end

  controller :users do
    get '/signup' => :new, :as => :signup
    post '/create' => :create, :as => :create_user
    get '/forgot' => :forgot, :as => :forgot
    post '/reset_password' => :reset_password, :as => :reset_password
    get '/me' => :edit, :as => :edit_user
    put '/me' => :update, :as => :update_user
    get '/user/:user_id' => :show, :as => :show_user
    get '/logout' => :logout, :as => :logout
    get '/login' => :login, :as => :login
    post '/create_session' => :create_session, :as => :create_session
  end

end
