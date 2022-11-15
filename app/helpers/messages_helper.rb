module MessagesHelper

    def check_unread_count(receiver_user, current_user)
        Room.get_unread_msg_count(receiver_user, current_user)
    end
end
