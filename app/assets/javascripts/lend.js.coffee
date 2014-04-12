# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
root = exports ? this
root.ItemDeadline = () ->
  $('#date_notice').fadeOut()
  attr = $('#lend_ItemId option:selected').attr('data-deadline')
  if attr
    $('#date_notice').fadeIn()
    $('#date_notice span').text(attr)

$('#edit-func').click ->
  $('.edit-btn').fadeToggle()
$('#del-func').click ->
  $('.del-btn').fadeToggle()

