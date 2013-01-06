Worksummarizer.Views.Home || = {}

class Worksummarizer.Views.Home.TicketsView extends Backbone.View
  initialize: (options) ->
    @render()

  events: ->
    'change .cb_desc': 'toggle_desc_all',
    'click .firstline': 'toggle_each_desc',

  toggle_desc_all: ->
    if $(".cb_desc").attr "checked"
      $(".ticket_desc").slideDown()
    else
      $(".ticket_desc").slideUp()

  toggle_each_desc: (e) ->
    $(e.target).closest('.each_ticket').find(".ticket_desc").slideToggle()


  render: ->
    that = @
    html = ""
    if window.tickets_col
      render_content window.tickets_col, that
      return @
    @tickets = new Worksummarizer.Collections.TicketsCollection()
    @tickets.fetch {
      success: (col, res) ->
        window.tickets_col = col
        render_content col, that


      error: (col, res) ->
        console.log "res"
        console.log res
    }
    return this

  render_content= (col, that) ->
    html = ""
    unassigned = [] 
    user_col = {}
    $(".user_info").each (i) ->
      user_col[$(this).attr('assembla_id')] = []

    col.each (m) ->
      if m.get('assigned_to_id') of user_col
        user_col[m.get('assigned_to_id')].push m

    html += "<input type='checkbox' class='cb_desc' /> Description"

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
    check_active_user_content()


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
