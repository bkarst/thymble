class CommentsController < ApplicationController

  layout false, :only => [:show]

  def index
    if params[:by]
      user = User.where(:username => params[:by]).first
      @comments = user.comments.where(:parent_comment_id => nil)
    elsif params[:upvoted]
      @comments = Comment.find(current_user.upvoted_comments.keys)
    elsif current_user.present?
      @selected_tab = 'threads'
      @comments = current_user.comments.where(:parent_comment_id => nil)    
    else 
      @comments = []
    end    
    #my comments, my saved comments, my upvoted comments
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def upvote
    comment = Comment.find(params[:id])
    if params[:add] && current_user.upvoted_comments[comment.id.to_s].blank?
      comment.upvoted(current_user)
    elsif params[:remove] && current_user.upvoted_comments[comment.id.to_s].present?
      comment.unvoted(current_user)
    end    
    render :json => {}
  end

  def parent
    comment = Comment.find(params[:id])
    if comment.parent_comment_id.present?
      parent_comment =  Comment.find(comment.parent_comment_id)
      redirect_to comment_path(parent_comment.id.to_s)
    else      
      redirect_to post_path(comment.post.url_title)
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    if permission_to_remove(comment)
      comment.active = false
      comment.save
    end    
    render :json => {}
  end

  def show
    @comment = Comment.find(params[:id])
    @post = @comment.post
  end

  def create    
    if current_user.blank?
      redirect_to signup_path
    else
      post = Post.find(params[:post_id])    
      new_comment = Comment.new(post: post, comment_text: params[:comment][:comment_text], user: current_user)
      if new_comment.save        
        post = new_comment.post
        post.comment_count = post.comment_count + 1
        post.save
        if params[:comment_id] != 'none'
          parent_comment = Comment.find(params[:comment_id])
          parent_comment.replies << new_comment.id.to_s
          parent_comment.save
          new_comment.parent_comment_id = parent_comment.id.to_s
          new_comment.nesting = parent_comment.nesting + 1
          new_comment.save
        end
        redirect_to post_path(post.url_title)
      else
        flash[:error_message] = "There was a problem saving your comment"
        redirect_to post_path(post.url_title)
      end
    end
  end

  def update
    comment = Comment.find(params[:comment_id])
    if params[:comment_text].present?
      comment.comment_text = params[:comment_text]
      comment.edited = true
      comment.save
    end
    redirect_to edit_comment_path(comment.id.to_s)
  end



end
