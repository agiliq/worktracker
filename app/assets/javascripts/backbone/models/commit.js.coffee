class Worksummarizer.Models.Commit extends Backbone.Model
  paramRoot: 'commit'


class Worksummarizer.Collections.CommitsCollection extends Backbone.Collection
  initialize: (options) ->
    @options = options
    console.log @options
    d = new Date @options.date
    d.setDate(d.getDate()+1)
    @options.date = d.getFullYear()+"-"+(d.getMonth()+1)+"-"+d.getDate()
  model: Worksummarizer.Models.Commit
  url: ->
    "/home/commits?date=#{@options.date}"
  comparator: (item) ->
    item.get 'author_name'


