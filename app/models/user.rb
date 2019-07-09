class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :member

  accepts_nested_attributes_for :member

  validates_presence_of :email, :member_id

  def has_position? description
    member.leaderships.map { |leadership| leadership.position.description }.include? description
  end

  def can? action, subject
    Permission.exists?(position: member.positions.pluck(:id), action: action, subject: subject)
  end
end
