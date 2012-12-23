Worksummarizer.Views.Home || = {}

class Worksummarizer.Views.Home.TicketsView extends Backbone.View
  initialize: (options) ->
    console.log "tickets view init"
    @render()

  events: ->
    'change .cb_desc': 'toggle_desc_all',
    'click .firstline': 'toggle_each_desc',

  toggle_desc_all: ->
    if $(".cb_desc").attr "checked"
      $(".ticket_desc").show()
    else
      $(".ticket_desc").hide()

  toggle_each_desc: (e) ->
    $(e.target).closest('.each_ticket').find(".ticket_desc").toggle()




  render: ->
    console.log "vew"
    that = @
    html = ""
    @tickets = new Worksummarizer.Collections.TicketsCollection()
    @tickets.fetch {
      success: (col, res) ->
        console.log 'suc'
        console.log col

        html = ""
        unassigned = [] 
        user_col = {}
        $(".user_info").each (i) ->
          user_col[$(this).attr('assembla_id')] = []

        col.each (m) ->
          if m.get('assigned_to_id') of user_col
            console.log "pushing"
            user_col[m.get('assigned_to_id')].push m
          else
            console.log "not"
        console.log user_col
        window.ti = user_col

        html += "<input type='checkbox' class='cb_desc' checked /> Description"


        for key, val of user_col
          name_text = $("[assembla_id="+key+"]").text()
          html += "<div class='"+key+" user_tickets'><h2>"+name_text+"</h2><div class='each_user_tickets'>"
          prev_space = ""
          i = 0
          for k,v of val
            if prev_space != v.get('space_name')
              if i!=0
                html += "<hr>"
              html += "<div class='space_name'>"+v.get('space_name')+"</div>"
              prev_space = v.get('space_name')

            html += "<div class='each_ticket' ><span class='firstline'><span class='ticket_status'>"+v.get('status')+"</span> - <span class='ticket_summary'>"+v.get('summary')+"</span></span><div class='ticket_desc'>"+v.get('description')+"</div></div>"
            i++

          html += "</div></div>"
        $(that.el).html html

          #user_col.each (user) ->
          #  if m.get('assigned_to_id') == null
          #    unassigned.push m.get('id')
          #  html += "<h2>"+$('.'+user[]['assigned_to_id']+'')+"</h2>"


      error: (col, res) ->
        console.log "res"
        console.log res
    }
    return this




