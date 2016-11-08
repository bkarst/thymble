module ApplicationHelper
  include MetaHelper
  def current_user
    @current_user ||= session[:current_user_id] && User.find(session[:current_user_id])
  end

  def render_replies(comment, nesting)
    @replies = Comment.find(comment.replies)
    @replies.each do |reply|
      puts nesting
      render partial: "comment", :locals => { comment: reply, nesting: 0 }
    end
    return nil
  end

  def comment_display_string(post)    
    post.comment_count == 0 ? "discuss" : "#{post.comment_count} Comments"
  end

  def permission_to_remove(post)
    current_user && ((post.user == current_user && post.created_at > 2.hours.ago) || current_user.admin )
  end

  def permission_to_edit(post)
    current_user && ((post.user == current_user && post.created_at > 2.hours.ago))
  end

  def selected_tab_class(tab, selected_tab)
    if tab == @selected_tab
      return 'tab-selected'
    end
    ''
  end

  def selected_string?(string1, string2)
    return "selected" if string1.to_s == string2.to_s
    ""
  end

end
