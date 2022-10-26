import consumer from "channels/consumer"

consumer.subscriptions.create({channel: "RoomChannel", room_id: $('#room').data("room-id")}, {
  connected() {
    console.log('connected')
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    console.log(data)
    $("#room").prepend(data['message'])
  }
});
