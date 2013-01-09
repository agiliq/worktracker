# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$("#cb_toggle_linked input[type='checkbox']").live
  change: (e)->
    if $(@).attr "checked"
      $(".linked").hide()
    else
      $(".linked").show()

custom_sort = (a, b) ->
    if $(a).text().toLowerCase()[0] > $(b).text().toLowerCase()[0]
      return 1
    if $(a).text().toLowerCase()[0] < $(b).text().toLowerCase()[0]
      return -1
    return 0

group_sort_append = (a, b) ->
  r = $(".#{a}_users_custom_box .users_list #{b}").remove()
  r.sort (a, b) ->
    custom_sort(a, b)
  r.prependTo($(".#{a}_users_custom_box .users_list"))

$(".user_name").live
  click: (e) ->
    if "linked" not in $(@).attr("class").split(" ")
      $(@).closest('.users_list').find('div').removeClass('selected')
      $(@).addClass 'selected'
      if $(@).closest('.github_users_custom_box').length > 0
        $("input[name='github_id']").val $(@).attr('id_from_provider')
      else if $(@).closest('.assembla_users_custom_box').length > 0
        $("input[name='assembla_id']").val $(@).attr('id_from_provider')

    else
      alert 'It is already linked'

$("#submit_link_users_custom_box").live
  click: (e)->
    e.preventDefault()
    if $("input[name='assembla_id']").val().trim().length == 0
      alert 'Select assembla id'
    else if $("input[name='github_id']").val().trim().length == 0
      alert 'Select Github Id'
    else
      $(@).closest('form').submit()


$(document).ready ->

  group_sort_append 'github', '.notlinked'
  group_sort_append 'github', '.linked'
  group_sort_append 'assembla', '.notlinked'
  group_sort_append 'assembla', '.linked'
