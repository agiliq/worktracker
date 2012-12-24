Worksummarizer.Views.Home || = {}

class Worksummarizer.Views.Home.UsersView extends Backbone.View
  initialize: (options) ->
    console.log ""
    @options = options
    @render()

  events: ->
    'change .cb_fresh_users_list': 'fresh_users_list',

  fresh_users_list: (e)->
    console.log "sdf"
    if $(e.target).attr "checked"
      @render()

  render: ->
    users_obj = new Worksummarizer.Collections.UsersCollection()
    that = @
    checked = ''
    if $(".cb_fresh_users_list").attr "checked"
      checked = 'checked'
    $(that.el).html "<span>Fetch Latest Users <input type='checkbox' class='cb_fresh_users_list' #{checked} />"

    if not $(".cb_fresh_users_list").attr "checked"
      if localStorage
        if localStorage.users_list
          users_list = JSON.parse localStorage.users_list
          if Object.keys(users_list).length > 0
            for key, val of users_list
              $(that.el).append "<span class='user_info' assembla_id='"+val.assembla_id+"'><span>"+val.name+"</span><img src='"+val.picture+"' class='profile_pic img-circle' /></span>"
            return


    if not $(".cb_fresh_users_list").attr "checked"
      if window.users_collection
        if window.users_collection.length > 0
          window.users_collection.each (m) ->
            $(that.el).append "<span class='user_info' assembla_id='"+m.get('assembla_id')+"'><span>"+m.get('name')+"</span><img src='"+m.get('picture')+"' class='profile_pic img-circle' /></span>"
          return


    users_obj.fetch { success: (col, res) ->
      window.users_collection = col
      users_list = {}
      i = 0
      col.each (m) ->
        $(that.el).append "<span class='user_info' assembla_id='"+m.get('assembla_id')+"'><span>"+m.get('name')+"</span><img src='"+m.get('picture')+"' class='profile_pic img-circle' /></span>"
        users_list[i] = {}
        users_list[i]['assembla_id'] = m.get('assembla_id')
        users_list[i]['name'] = m.get('name')
        users_list[i]['picture'] = m.get 'picture'
        i++
      localStorage.users_list = JSON.stringify users_list
    , err: (col, res) ->
        console.log res
        console.log "err"
    }

