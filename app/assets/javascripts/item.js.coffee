# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
root = exports ? this

modify = ->
  $('#edit-func').click ->
    $('.edit-btn').fadeToggle()
  $('#del-func').click ->
    $('.del-btn').fadeToggle()

$(document).on('page:load', modify)
