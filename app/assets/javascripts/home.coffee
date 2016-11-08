# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->    
  $('body').on('click', '.flag-post', (e) ->        
    postId = $(e.target).attr('data-id')
    url = "/flag_post/#{postId}"
    $.ajax
        method: 'get'
        data: {"add": true}
        url: url
        complete: () =>                    
          $(e.target).removeClass('flag-post')
          $(e.target).addClass('unflag-post')
          $(e.target).html("unflag")
          console.log "flagged"

  );
  $('body').on('click', '.unflag-post', (e) ->
    postId = $(e.target).attr('data-id')
    url = "/flag_post/#{postId}"
    $.ajax
        method: 'get'
        data: {"remove": true}
        url: url
        complete: () ->
          console.log "unflagged"
          $(e.target).removeClass('unflag-post')
          $(e.target).addClass('flag-post')
          $(e.target).html("flag")
          console.log "unflagged"
  );
  $('body').on('click', '.favorite-post', (e) ->        
    postId = $(e.target).attr('data-id')
    url = "/favorite_post/#{postId}"    
    $.ajax
        method: 'get'
        data: {"add": true}
        url: url
        complete: () ->
          $(e.target).removeClass('favorite-post')
          $(e.target).addClass('unfavorite-post')
          $(e.target).html("unfavorite")
          console.log "favorited"
  );
  $('body').on('click', '.unfavorite-post', (e) ->
    postId = $(e.target).attr('data-id')
    url = "/favorite_post/#{postId}"
    $.ajax
        method: 'get'
        data: {"remove": true}
        url: url
        complete: () ->
          $(e.target).removeClass('unfavorite-post')
          $(e.target).addClass('favorite-post')
          $(e.target).html("favorite")
          console.log "unfavorited"          
  );
  $('body').on('click', '.upvote-post', (e) ->
    postId = $(e.target).attr('data-id')
    url = "/upvote/#{postId}"
    $.ajax
        method: 'get'
        data: {"add": true}
        url: url
        complete: () ->          
          selector = ".upvote-post[data-id='#{postId}']"
          $(selector).invisible()
          selector = ".unupvote-post[data-id='#{postId}']"          
          $(selector).show()
          console.log "upvoted"
  );
  $('body').on('click', '.unupvote-post', (e) ->    
    postId = $(e.target).attr('data-id')
    url = "/upvote/#{postId}"
    $.ajax
        method: 'get'
        data: {"remove": true}
        url: url
        complete: () ->
          $(e.target).parent().hide()
          selector = ".upvote-post[data-id='#{postId}']"
          $(selector).visible()
  );
  $('body').on('click', '.remove-post', (e) ->
    if window.confirm "Are you sure?"
      postId = $(e.target).attr('data-id')
      url = "/post/#{postId}"
      $.ajax
          method: 'delete'        
          url: url
          complete: () ->
            selector = "tr[post-id='#{postId}']"
            $(selector).invisible()
  );
  $('body').on('click', '.remove-comment', (e) ->
    if window.confirm "Are you sure?"
      commentId = $(e.target).attr('data-id')
      url = "/delete_comment/#{commentId}"
      $.ajax
          method: 'delete'
          url: url
          complete: () ->
            selector = "tr[comment-id='#{commentId}']"
            $(selector).hide()
  );
  $('body').on('click', '.upvote-comment', (e) ->        
    commentId = $(e.target).attr('data-id')
    url = "/upvote_comment/#{commentId}"
    
    $.ajax
        method: 'get'
        data: {"add": true}
        url: url
        complete: () =>
          selector = ".unvote-comment[data-id='#{commentId}']"
          $(selector).show()
          selector = ".upvote-comment[data-id='#{commentId}']"
          $(selector).invisible()
          console.log "comment upvoted"

  );
  $('body').on('click', '.unvote-comment', (e) ->
    commentId = $(e.target).attr('data-id')
    url = "/upvote_comment/#{commentId}"
    $.ajax
        method: 'get'
        data: {"remove": true}
        url: url
        complete: () ->          
          selector = ".unvote-comment[data-id='#{commentId}']"
          $(selector).invisible()
          selector = ".upvote-comment[data-id='#{commentId}']"
          $(selector).visible()
          console.log "comment unvoted"
  );
  $('body').on('click', '.collapse-comment', (e) ->
    commentId = $(e.target).attr('data-id')
    url = "/upvote_comment/#{commentId}"
    selector = "tr[comment-id='#{commentId}']"
    $(selector).hide()
    selector = ".replies[data-id='#{commentId}']"
    $(selector).hide()
    selector = "tr.expand-comment[data-id='#{commentId}']"
    $(selector).show()
    
  );
  $('body').on('click', '.expand-comment', (e) ->
    commentId = $(e.target).attr('data-id')    
    url = "/upvote_comment/#{commentId}"
    selector = "tr[comment-id='#{commentId}']"
    $(selector).show()
    selector = ".replies[data-id='#{commentId}']"
    $(selector).show()
    selector = "tr.expand-comment[data-id='#{commentId}']"
    $(selector).hide()
  );

  $('body').on('change', '.comment-sort-select', (e) ->
    sort = $(e.target).val()    
    url = window.location.pathname + "?comment_order=#{sort}"
    window.location.href = url
  );

jQuery.fn.visible = ->
  @css 'visibility', 'visible'

jQuery.fn.invisible = ->
  @css 'visibility', 'hidden'

jQuery.fn.visibilityToggle = ->
  @css 'visibility', (i, visibility) ->
    if visibility == 'visible' then 'hidden' else 'visible'

# ---
# generated by js2coffee 2.2.0