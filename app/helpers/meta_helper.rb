module MetaHelper
  def get_title
    if @post.present?
      "#{Constants::APP_NAME} | #{@post.title}"
    else
      Constants::APP_NAME
    end
  end

  def get_meta_title
    if @post.present?
      "#{Constants::APP_NAME} | #{@post.title}"
    else
      Constants::APP_NAME
    end
  end

  def get_meta_url
    request.original_url    
  end

  def get_site_name
    Constants::APP_NAME
  end

  def get_meta_description
    if @post.present?
      "Discuss this article and similar news at #{Constants::APP_NAME}."
    else
      "A news discussion platform for free-thinking individuals who want to make a difference."
    end
  end

  def get_meta_keywords
    if @post.present?
      @post.title.split(' ').join(', ')
    else
      "politics, discussion, forum"
    end
  end
end