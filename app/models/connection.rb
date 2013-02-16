class Connection < ActiveRecord::Base
  """
  It was built to facilitate the relationship between User and Room models
  """
  belongs_to :user
  belongs_to :room
  attr_accessible :user_status
end
