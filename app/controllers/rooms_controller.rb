class RoomsController < ApplicationController
  def index
    # We will fetch all rooms along with messages to check in view for new message for every user
    @users = User.all_except(current_user).includes(:rooms, :messages) if current_user.present?
  end

  def create
    room = check_if_room_exist(params[:receiver_id])
    unless room.present?
      room = Room.create(sender: current_user, receiver_id: params[:receiver_id])
    end
    redirect_to new_room_message_path(room)
  end

  private

  def check_if_room_exist(receiver_id)
    Room.where("(sender_id = ? and receiver_id = ?) or (sender_id = ? and receiver_id = ?)",
               current_user.id, receiver_id, receiver_id, current_user.id).first
  end
end
