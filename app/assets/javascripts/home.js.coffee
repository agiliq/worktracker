# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
window.onload = ->
  g_globalObject = new JsDatePick(
    useMode: 1
    isStripped: true
    target: "mycalendar"
  )
  window.selected_date = g_currentDateObject
  @view = new Worksummarizer.Views.Home.CommitsView(g_currentDateObject)
  $("#ajax_content").html @view.render().el
  
  g_globalObject.setOnSelectedDelegate ->
    obj = g_globalObject.getSelectedDay()
    window.selected_date = obj
    @view = new Worksummarizer.Views.Home.CommitsView(obj)
    $("#ajax_content").html @view.render().el
    #alert "a date was just selected and the date is : " + obj.day + "/" + obj.month + "/" + obj.year

$(document).ajaxStart ->
  $("#loading_div").slideDown()
$(document).ajaxStop ->
  $("#loading_div").slideUp(200)

