class Worksummarizer.Routers.HomeRouter extends Backbone.Router
  initialize: (options) ->
    console.log ""

  routes:
    "index"    : "index"
    ".*"        : "index"


  index: ->
    console.log "Router initiated"

