class Worksummarizer.Routers.HomeRouter extends Backbone.Router
  initialize: (options) ->
    console.log ""

  routes:
    "index"    : "index"
    ".*"        : "index"


  index: ->
    console.log "Router initiated"
    users_obj = new Worksummarizer.Collections.UsersCollection()
    users_obj.fetch { success: (col, res) ->
      $("#users_list").show()
      col.each (m) ->
        profile_pic = ""
        console.log m.get('picture')
        if m.get('picture') is "" or typeof(m.get('picture')) is "undefined"
          profile_pic = "http://localhost:3000/assets/home/no_pic.jpg"
        else
          profile_pic = m.get('picture')
        $("#users_list").append "<span class='user_info "+m.get('id')+"'><span>"+m.get('name')+"</span><img src='"+profile_pic+"' class='profile_pic' /></span>"
    , err: (col, res) ->
        console.log res
        console.log "err"
    }

    

