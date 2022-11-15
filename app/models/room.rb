class Room < ApplicationRecord
  belongs_to :sender, foreign_key: :sender_id, class_name: 'User'
  belongs_to :receiver, foreign_key: :receiver_id, class_name: 'User'

  has_many :messages, dependent: :destroy

  def self.check_if_room_exist(receiver_id, current_user_id)
    Room.where("(sender_id = ? and receiver_id = ?) or (sender_id = ? and receiver_id = ?)",
               current_user_id, receiver_id, receiver_id, current_user_id).first
  end

  def self.get_unread_msg_count(receiver_user, current_user)
    room = check_if_room_exist(receiver_user.id, current_user.id)
    return 0 if room.nil?

    room.get_unread_msg(receiver_user).count
  end

  def get_unread_msg(receiver_user)
    messages.where(status: false, user: receiver_user)
  end
end
