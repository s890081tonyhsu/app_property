# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

modify = ->
  $('#edit-func').click ->
    $('.edit-btn').fadeToggle()
  $('#del-func').click ->
    $('.del-btn').fadeToggle()

$(document).ready(modify)
$(document).on('page:load', modify)
