class User < ActiveRecord::Base
  attr_accessible :email, :name, :password, :password_confirmation
  has_many :connections
  has_many :rooms, through: :connections
  has_many :grids
  has_many :chats

  has_secure_password

  before_save { |user| user.email = email.downcase }
  before_save :create_remember_token

  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
            format:     { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  # Default json
  def as_json(options = nil)
    super(
              {only: [:name, :email, :created_at, :id]})
  end




  private
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
