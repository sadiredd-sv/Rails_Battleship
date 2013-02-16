class Chat < ActiveRecord::Base
  attr_accessible :message, :receiver_id, :room_id
  #belongs_to :user
  #belongs_to :room

  def isSendToRoom?
    @room_id != nil
  end

  def isSendToPerson?
    @to_user_id != nil
  end
end
