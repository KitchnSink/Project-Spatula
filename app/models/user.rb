class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of :username
  validates_uniqueness_of :username

  has_many :posts, foreign_key: "author_id"

  def anonymous?
    false
  end

  def authenticated?
    true
  end

  def admin?
    self.role == 'admin'
  end
end
