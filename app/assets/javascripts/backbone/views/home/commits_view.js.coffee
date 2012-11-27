Worksummarizer.Views.Home ||= {}

class Worksummarizer.Views.Home.CommitsView extends Backbone.View
  initialize: (options) ->
    console.log ""
    @options = options
    console.log options.month

  render: =>
    $("#ajax_content").append "<h1>From commitsView</h1>"
    @commits = new Worksummarizer.Collections.CommitsCollection(@options)
    @commits.fetch  {success: (col, res) ->
      console.log "suc"
      window.kj = col
      console.log col
      prev_author = ""
      #if (""+selected_date.day).length == 1
      #  selected_date.day = "0"+selected_date.day
      #if (""+selected_date.month).length == 1
      #  selected_date.month = "0"+selected_date.month
      not_today_count = 0
      col.each (m) ->
        #if m.get('date').indexOf(selected_date.year+"-"+selected_date.month+"-"+selected_date.day) is -1
        commit_date = new Date m.get 'date'
        unless commit_date.getFullYear()+"-"+(commit_date.getMonth()+1)+"-"+commit_date.getDate() is selected_date.year+"-"+selected_date.month+"-"+selected_date.day
          console.log "not"
          not_today_count += 1
        else
          console.log "today"

      if not_today_count is col.length
        $("#ajax_content").html "<h2>No commits for this day</h2>"
      else
        col.each (m) ->
          commit_date = new Date m.get 'date'

          
          #if m.get('date').indexOf(selected_date.year+"-"+selected_date.month+"-"+selected_date.day) > -1
          if commit_date.getFullYear()+"-"+(commit_date.getMonth()+1)+"-"+commit_date.getDate() is selected_date.year+"-"+selected_date.month+"-"+selected_date.day
          
            unless m.get("author_id") is prev_author
              $("#ajax_content").append "<h2 class='author_name'>"+m.get('author_name')+"</h2>"
              prev_author = m.get('author_id')
            $("#ajax_content").append "<div class='"+m.get('author_id')+"'>"+m.get('date')+" --- "+commit_date.getHours()+":"+commit_date.getMinutes()+" --- "+m.get('title')+"</div>"

      console.log res
    , err:(model, res) ->
      console.log "err"
      console.log model
      console.log res
    }

    return this

