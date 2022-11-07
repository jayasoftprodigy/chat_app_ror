import consumer from "channels/consumer"

const currentUserId= $('#room').data("current-user-id");

consumer.subscriptions.create({channel: "RoomChannel", room_id: $('#room').data("room-id")}, {
  connected() {
    console.log('connected')
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    console.log(data);
    if (currentUserId != data.current_user_id){
      data.message = data.message.replace( 'writer-user', '' );
    }else{
      $("#message_body").val('');
    }
    $("#room").append(data['message']);
    document.getElementById('room').scrollTop =  document.getElementById('room').scrollHeight;
  }
});
