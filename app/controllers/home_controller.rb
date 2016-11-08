class HomeController < ApplicationController

  include HomeHelper

  EXPIRATION_DATE = 3.years.ago

  def index 
    #search, myposts, new, most commented, my hidden, my saved, my upvoted, ask
    @page = params[:p].to_i    
    @per_page = 10
    offset = @per_page * @page
    @starting_index = @page * @per_page + 1
    if params[:from]
      @posts = Post.where(active: true, domain: params[:from]).order_by(:created_at => 'desc')
      set_display_more
    elsif params[:by]
      user = User.where(username: params[:by]).first      
      @posts = Post.where(active: true, user: user).order_by(:created_at => 'desc')
      set_display_more
    elsif params[:submitted]
      user = User.where(username: current_user.username).first      
      @posts = Post.where(active: true, user: user).order_by(:created_at => 'desc')
      set_display_more
    elsif params[:newest]
      @selected_tab = 'new'
      user = User.where(username: params[:by]).first      
      @posts = Post.where(active: true).order_by(:created_at => 'desc').offset(offset).limit(@per_page)
      set_display_more
    elsif params[:favorited]
      @posts = Post.find(current_user.saved_posts.keys).delete_if{|x| x.active == false}
      set_display_more
      @posts = @posts[offset, @per_page]
    elsif params[:user_favorited]
      user = User.where(active: true, username: params[:user_favorited]).first
      @posts = Post.find(user.saved_posts.keys).delete_if{|x| x.active == false}
      set_display_more
      @posts = @posts[offset, @per_page]      
    elsif params[:my_upvoted]
      @selected_tab = 'top'
      @posts = Post.find(current_user.upvoted_posts.keys).delete_if{|x| x.active == false}
      set_display_more
      @posts = @posts[offset, @per_page]
    elsif params[:top]
      @selected_tab = 'top'
      @posts = Post.where(active: true, :created_at.gt => EXPIRATION_DATE).order_by(:points => 'desc').offset(offset).limit(@per_page)
      set_display_more
    elsif params[:most_commented]
      @selected_tab = 'most_commented'
      @posts = Post.where(active: true, :created_at.gt => EXPIRATION_DATE).order_by(:comment_count => 'desc').offset(offset).limit(@per_page)
      set_display_more
    elsif params[:q]
      wild_card_regex = /#{params[:q]}/i
      @posts = Post.where(active: true, title: wild_card_regex).order_by(:points => 'desc')
      set_display_more
    elsif params[:q]
      wild_card_regex = /#{params[:q]}/i
      @posts = Post.where(active: true, title: wild_card_regex).order_by(:points => 'desc')
      set_display_more
    else
      @posts = Post.where(active: true, :created_at.gt => EXPIRATION_DATE)      
      set_display_more
      @posts = @posts.to_a.sort_by(&:front_page_score).reverse
      @posts = @posts[offset, @per_page]
    end
    array = params.delete_if{|k, v| k == 'action' || k == 'controller' || k == 'p' }.map{|k,v| "#{k}=#{v}" }
    array << [ "p=#{@page + 1}"]
    @paging_string = array.join('&')
  end

  def about

  end

  def faq

  end

  def welcome
    @selected_tab = 'welcome'    
  end

  def contact

  end

  def guidelines

  end

  def lists

  end  


end
