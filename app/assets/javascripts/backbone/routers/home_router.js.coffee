class Worksummarizer.Routers.HomeRouter extends Backbone.Router
  initialize: (options) ->
    console.log ""

  routes:
    "index"    : "index"
    ".*"        : "index"


  index: ->
    console.log "Router initiated"
    users_view = new Worksummarizer.Views.Home.UsersView({el: $('#users_list')})
    #commits_view = new Worksummarizer.Views.Home.CommitsView({el: $('#ajax_content')})
    tickets_view = new Worksummarizer.Views.Home.TicketsView({el: $('#ajax_content')})
    users_view.render()

    

