import consumer from "channels/consumer"

const currentUserId = $('#chat-user-list').data("current-user-id");

if (currentUserId !== undefined){
  consumer.subscriptions.create({channel: "NotifyChannel", current_user_id: currentUserId}, {
    connected() {
      console.log('connected new channel')
      // Called when the subscription is ready for use on the server
    },
  
    disconnected() {
      // Called when the subscription has been terminated by the server
    },
  
    received(data) {
      $(`#user-${data.current_user_id} td:last-child`).html(`<span class="dot"><span>${data.unread_count}</span></span>`)
    }
  });
}

