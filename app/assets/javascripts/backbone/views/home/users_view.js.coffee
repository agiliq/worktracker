Worksummarizer.Views.Home || = {}

class Worksummarizer.Views.Home.UsersView extends Backbone.View
  initialize: (options) ->
    console.log ""
    @options = options
    @render()

  render: ->
    users_obj = new Worksummarizer.Collections.UsersCollection()
    that = @

    if window.users_collection
      if window.users_collection.length > 0
        $(that.el).html ""
        window.users_collection.each (m) ->
          $(that.el).append "<span class='user_info' assembla_id='"+m.get('assembla_id')+"'><span>"+m.get('name')+"</span><img src='"+m.get('picture')+"' class='profile_pic img-circle' /></span>"
        return

    users_obj.fetch { success: (col, res) ->
      window.users_collection = col
      $(that.el).show()
      $(that.el).html ""
      col.each (m) ->
        $(that.el).append "<span class='user_info' assembla_id='"+m.get('assembla_id')+"'><span>"+m.get('name')+"</span><img src='"+m.get('picture')+"' class='profile_pic img-circle' /></span>"
    , err: (col, res) ->
        console.log res
        console.log "err"
    }

