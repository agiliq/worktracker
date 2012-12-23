Worksummarizer.Views.Home ||= {}

class Worksummarizer.Views.Home.CommitsView extends Backbone.View

  initialize: (options) ->
    @options = options
    if Object.keys(options).length == 1
      console.log "no options"
      d = new Date()
      @options = {}
      @options['date'] = d.getFullYear()+"-"+(d.getMonth()+1)+"-"+d.getDate() 
    else
      console.log "yes options"
    @render()

  render: =>
    @commits = new Worksummarizer.Collections.CommitsCollection(@options)
    that = @
    @commits.fetch  {success: (col, res) ->
      prev_author = ""
      prev_author_end = ""
      not_today_count = 0
      selected_date = new Date that.options.date
      selected_date.setDate(selected_date.getDate()-1)
      console.log JSON.stringify(selected_date)
      $(that.el).html "Date : "+(selected_date.getFullYear()+" - "+(selected_date.getMonth()+1)+" - "+selected_date.getDate())
      content = ""
      firsttime = "yes"
      col.each (m) ->
        commit_date = new Date m.get 'date'
        unless commit_date.getFullYear()+"-"+(commit_date.getMonth()+1)+"-"+commit_date.getDate() is selected_date.getFullYear()+"-"+(selected_date.getMonth()+1)+"-"+selected_date.getDate()
          console.log "not"
          not_today_count += 1
        else
          console.log "today"
          commit_date = new Date m.get 'date'

          
          #if m.get('date').indexOf(selected_date.year+"-"+selected_date.month+"-"+selected_date.day) > -1
          #if commit_date.getFullYear()+"-"+(commit_date.getMonth()+1)+"-"+commit_date.getDate() is selected_date.getFullYear()+"-"+(selected_date.getMonth()+1)+"-"+selected_date.getDate()
          
          unless m.get("author_id") is prev_author
            if firsttime != "yes"
              content += "</div><div class='user_commits "+m.get('author_id')+"'><h2 class='author_name'>"+m.get('author_name')+"</h2>"
            else
              content += "<div class='user_commits "+m.get('author_id')+"'><h2 class='author_name'>"+m.get('author_name')+"</h2>"
            firsttime = "no"

            prev_author = m.get('author_id')
          content += "<div class='row_info "+m.get('author_id')+"'><span class='time_info'> "+commit_date.getHours()+":"+commit_date.getMinutes()+"</span> @ <span class='space_name_info'> "+m.get('space_name')+"</span><span class='operation_info'><a href='"+m.get('url')+"'> "+m.get('operation')+"</a></span><br><span class='title_info'>"+m.get('title')+"</span>"
          if typeof(m.get('whatchanged')) != "undefined"
            content += "<br><span class='whatchanged_info'>"+m.get('whatchanged')+"<span></span></div>"
          else
            console.log m.get('whatchanged')
            content += "</div>"
            #unless m.get("author_id") is prev_author_end
            #  if firsttime != "yes"
            #    content += "</div>"
            #  firsttime = "no"
            #  prev_author_end = m.get('author_id')

      $(that.el).append content


      if not_today_count is col.length
        $(that.el).append "<h2>No commits for this day</h2>"
      check_active_user_content()

      console.log res
    , err:(model, res) ->
      console.log "err"
      console.log model
      console.log res
    }

    return this


check_active_user_content = (that)->
    if that 
      $(that).toggleClass("active")
    if $(".user_info.active").length == 0 
      $(".user_tickets").show()
      $(".user_commits").show()
    else
      $(".user_tickets").hide()
      $(".user_commits").hide()
      for key in $(".user_info.active")
        $('.'+$(key).attr('assembla_id')).show()

