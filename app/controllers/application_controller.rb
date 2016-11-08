class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  def current_user
    @current_user ||= session[:current_user_id] && User.find(session[:current_user_id])
  end

  def permission_to_remove(post)
    current_user && ((post.user == current_user && post.created_at > 2.hours.ago) || current_user.admin )
  end

  def permission_to_edit(post)
    current_user && ((post.user == current_user && post.created_at > 2.hours.ago))
  end

  def selected_string?(string1, string2)
    return "selected" if string1.to_s == string2.to_s
    ""
  end


end
