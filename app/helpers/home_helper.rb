module HomeHelper

  def set_display_more
    @display_more = false
    if @posts.present? && @posts.count > (@starting_index + @per_page)
      @display_more = true
    end    
  end

end
