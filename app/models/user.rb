require 'bcrypt'

class User < ActiveRecord::Base
  has_many :wishes
  has_many :friends, :class_name => "Friends", :foreign_key => "friend_id"
  has_many :users_friended, :through => :friends, :source => :friended
  has_many :friendings, :class_name => "Friends", :foreign_key => "friended_id"
  has_many :users_friending, :through => :friendings, :source => :friender

  validates :handle, presence: true
  validates :handle, uniqueness: true
  validates :email, presence: true
  validates :email, uniqueness: true
  # validates :handle, format: { with: /\A[a-z0-9_-]{3,20}\z/}
  validates :name, presence: true

  include BCrypt
  
  def password
    @password || Password.new(password_hash)
  end

  def password=( new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def authenticate(password)
    self.password == password
  end

end