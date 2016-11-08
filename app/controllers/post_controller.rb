class PostController < ApplicationController

  def show
    @post = Post.where(url_title: params[:url_title]).first
    @comment_order = params[:comment_order].present? ? params[:comment_order] : 'newest'
  end

  def create
    post = Post.new(post_params)
    post.user = current_user    
    if post.has_url_and_text_valid? && post.url_valid? && post.save      
      redirect_to root_path(:new => true)
    else      
      if !post.has_url_and_text_valid?
        flash[:error_message] = "You must either submit text or a url."
      elsif !post.url_valid?
        flash[:error_message] = "The url has already been submitted."
      else
        flash[:error_message] = post.errors.messages.first.last.first
      end      
      redirect_to new_post_path
    end
  end

  def update
    post = Post.find(params[:id])
    if current_user && current_user == post.user
      post.title = params[:title]      
      post.text = params[:text]
      post.edited = true
      if post.has_url_and_text_valid? && post.save      
        redirect_to edit_post_path(params[:id])
      else      
        if !post.has_url_and_text_valid?
          flash[:error_message] = "You must either submit text or a url."
        elsif !post.url_valid?
          flash[:error_message] = "The url has already been submitted."
        else
          flash[:error_message] = post.errors.messages.first.last.first
        end      
      redirect_to edit_post_path(params[:id])
    end
    end
  end

  def edit  
    @post = Post.find(params[:id])
  end    

  def flag
    post = Post.find(params[:id])
    if params[:add] && current_user.flagged_posts[post.id.to_s].blank?
      current_user.flagged_posts[post.id.to_s] = Time.now  
      post.flagged_count = post.flagged_count + 1
    elsif params[:remove] && current_user.flagged_posts[post.id.to_s].present?
      current_user.flagged_posts.delete(post.id.to_s)
      post.flagged_count = post.flagged_count - 1
    end
    post.save
    current_user.save    
    render :json => {}
  end

  def favorite    
    post = Post.find(params[:id])
    if params[:add] && current_user.saved_posts[post.id.to_s].blank?
      current_user.saved_posts[post.id.to_s] = Time.now
      post.favorite_count = post.favorite_count + 1
    elsif params[:remove] && current_user.saved_posts[post.id.to_s].present?
      post.favorite_count = post.favorite_count - 1
      current_user.saved_posts.delete(post.id.to_s)
    end
    post.save
    current_user.save    
    render :json => {}
  end

  def upvote
    post = Post.find(params[:id])
    if params[:add] && current_user.upvoted_posts[post.id.to_s].blank?
      post.upvoted(current_user)
    elsif params[:remove] && current_user.upvoted_posts[post.id.to_s].present?
      post.unvoted(current_user)
    end    
    render :json => {}
  end

  def delete
    post = Post.find(params[:id])
    if current_user.admin || post.user == current_user
      post.active = false
      post.save
    end
    render :json => {}
  end

  def new
    @selected_tab = 'submit'
    if current_user.blank?
      flash[:error_message] = "sign in or sign up to submit a link"
      redirect_to signup_path
    end
  end


  private
    # Using a private method to encapsulate the permissible parameters is
    # just a good pattern since you'll be able to reuse the same permit
    # list between create and update. Also, you can specialize this method
    # with per-user checking of permissible attributes.
    def post_params
      params.require(:post).permit(:url, :text, :title)
    end

end
