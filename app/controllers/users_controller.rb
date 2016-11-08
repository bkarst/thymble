class UsersController < ApplicationController

  layout false, :only => [:new]

  def new

  end

  def update
    if current_user
      current_user.about = params[:about]
      current_user.email = params[:email]
      current_user.save
      redirect_to edit_user_path
    else
      redirect_to root_path
    end
  end

  def create        
    user = User.new(user_params)

    if user.email_valid? && user.save
      session[:current_user_id] = user.id.to_s
      redirect_to welcome_path
    else
      if user.email_valid? == false
        flash[:error_message] = "email address already taken"
      else
        flash[:error_message] = user.errors.messages.first.last.first
      end
      redirect_to signup_path
    end
  end

  def login

  end

  def show    
    @user = User.where(:username => params[:user_id]).first
  end

  def reset_password    
    redirect_to root_path
  end

  def edit
    @selected_tab = 'profile'
  end

  def logout 
    reset_session
    redirect_to root_path
  end

  def forgot

  end

  def create_session    
    user = User.where(username: user_params["username"]).first
    if user && user.authenticate(user_params["password"])
      session[:current_user_id] = user.id.to_s
      redirect_to root_path      
    else
      flash[:error_message] = "there was a problem your your login information"
      redirect_to signup_path
    end    
  end

  private
    # Using a private method to encapsulate the permissible parameters is
    # just a good pattern since you'll be able to reuse the same permit
    # list between create and update. Also, you can specialize this method
    # with per-user checking of permissible attributes.
    def user_params
      params.require(:user).permit(:username, :email, :password)
    end

end
