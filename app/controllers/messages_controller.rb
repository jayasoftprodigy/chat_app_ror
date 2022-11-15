class MessagesController < ApplicationController

  before_action :set_room, only: :new
  before_action :find_other_user, only: :new

  def new
    @messages = @room.messages.order(:created_at)
    # @room.messages.last.update(status: true)
    @room.get_unread_msg(find_other_user).update_all(status: true)
  end

  def create
    @message = current_user.messages.new(message_params)
    @message.save

    @room = Room.find(message_params[:room_id])
    @unread_count = @room.get_unread_msg(current_user).count
    ActionCable.server.broadcast("notify_channel_#{find_other_user.id}", {unread_count: @unread_count, current_user_id: current_user.id})
    ActionCable.server.broadcast("room_channel_#{@message.room_id}", { message: message_body(@message).html_safe, room_id: @message.room_id, current_user_id: current_user.id })
  end

  private

  def message_params
    params.require(:message).permit(:room_id, :body)
  end

  def message_body(message)
    # class_name = "chat-message-group"
    # class_name += " writer-user" if @message.user_id == current_user.id
    "<div class='chat-message-group writer-user'>\
      <div class='chat-messages'>\
        <div class='message'>#{message.body}</div>\
        <div class='from'>#{message.created_at}</div>\
      </div>\
    </div>"
  end

  def set_room
    @room = Room.find(params[:room_id])
  end

  def find_other_user
    @other_user = @room.sender == current_user ? @room.receiver : @room.sender
  end
end
