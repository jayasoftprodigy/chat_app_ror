class RoomsController < ApplicationController
  def index
    @users = User.all_except(current_user) if current_user.present?
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
