# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

date_pick = ->
  $('#datepick').datepicker
    format:"yyyy-mm-dd"
    clearBtn:true

sort_audit = ->
  $('#sort_audit button').click ->
    status = $(this).attr('statusval')
    console.log status
    if $(this).is('.active')
      $('.ItemLendStatus_'+status).fadeOut()
      $(this).removeClass('active')
    else
      $('.ItemLendStatus_'+status).fadeIn()
      $(this).addClass('active')

$(document).ready(sort_audit)
$(document).ready(date_pick)
$(document).on('page:load', sort_audit)

root = exports ? this
root.ItemDeadline = () ->
  $('#date_notice').fadeOut()
  attr = $('#lend_ItemId option:selected').attr('data-deadline')
  if attr
    $('#date_notice').fadeIn()
    $('#date_notice span').text(attr)
    $('#slideContainer input').attr('max', attr)


