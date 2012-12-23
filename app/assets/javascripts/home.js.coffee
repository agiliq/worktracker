# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#window.onload = ->
#  g_globalObject = new JsDatePick(
#    useMode: 1
#    isStripped: true
#    target: "mycalendar"
#  )
#  window.selected_date = g_currentDateObject
#  @view = new Worksummarizer.Views.Home.CommitsView(g_currentDateObject)
#  $("#ajax_content").html @view.render().el
#  
#  g_globalObject.setOnSelectedDelegate ->
#    obj = g_globalObject.getSelectedDay()
#    window.selected_date = obj
#    @view = new Worksummarizer.Views.Home.CommitsView(obj)
#    $("#ajax_content").html @view.render().el
#    #alert "a date was just selected and the date is : " + obj.day + "/" + obj.month + "/" + obj.year

$(document).ajaxStart ->
  $("#loading_div").slideDown()
$(document).ajaxStop ->
  $("#loading_div").slideUp(200)


$(".tickets").live
  click: (e) ->
    @view = new Worksummarizer.Views.Home.TicketsView({el: $('#ajax_content')})
    #$("#ajax_content").html @view.render().el
    

$(".commits").live
  click: (e) ->
    @view = new Worksummarizer.Views.Home.CommitsView({el: $('#ajax_content')})

$(".nav li").live
  click: () ->
    $(".nav li").removeClass "active"
    $(this).addClass "active"

$(".user_info").live
  click: (e) ->
    check_active_user_content(@)



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
