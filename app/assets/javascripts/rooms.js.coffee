# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->

#  // On click Ready button
  $(".change-user-status").on('click', () ->
    console.log('changing status')
    $.ajax({
      type: "POST",
      dataType: "json",
      url: "/rooms/"+Globals.room_id+"/change_status",
      data: { status: 'join'}
    }).done( ( msg ) ->
      console.log("status changed: " + msg )
    )
  )

  $(".unchange-user-status").on('click', () ->
    console.log('changing status')
    $.ajax({
    type: "POST",
    dataType: "json",
    url: "/rooms/"+Globals.room_id+"/change_status",
    data: { status: 'not ready'}
    }).done( ( msg ) ->
      console.log("status changed: " + msg )
    )
  )



