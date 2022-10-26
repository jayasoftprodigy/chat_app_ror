class MessagesController < ApplicationController

  def new
    @room = Room.find(params[:room_id])
    @messages = @room.messages.order(created_at: :desc)
  end

  def create
    @message = current_user.messages.new(message_params)
    @message.save

    ActionCable.server.broadcast("room_channel_#{@message.room_id}", { message: message_body(@message).html_safe, room_id: @message.room_id })
  end

  private

  def message_params
    params.require(:message).permit(:room_id, :body)
  end

  def message_body(message)
    "<strong>#{message.user.email}</strong>\
    <p>#{message.body}</p>\
    <hr>"
  end
end
