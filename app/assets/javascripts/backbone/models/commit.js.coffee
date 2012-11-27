class Worksummarizer.Models.Commit extends Backbone.Model
  paramRoot: 'commit'


class Worksummarizer.Collections.CommitsCollection extends Backbone.Collection
  initialize: (options) ->
    @options = options
    console.log "Dateis?#{@options.year}-#{@options.month}-#{@options.day}"
  model: Worksummarizer.Models.Commit
  url: ->
    @myday = new Date()
    @myday.setFullYear @options.year
    @myday.setMonth @options.month
    @myday.setDate @options.day+1

    console.log "/home/commits?date=#{@myday.getFullYear()}-#{@myday.getMonth()}-#{@myday.getDate()}"
    "/home/commits?date=#{@myday.getFullYear()}-#{@myday.getMonth()}-#{@myday.getDate()}"
  comparator: (item) ->
    item.get 'author_name'


