class NotifyChannel < ApplicationCable::Channel
  def subscribed
    stream_from "notify_channel_#{params[:current_user_id]}"
    # stream_from "some_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

end
