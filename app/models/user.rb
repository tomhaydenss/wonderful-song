class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  attr_reader :membership_id, :birthdate

  validate :valid_member
  validates :member_id, uniqueness: true, if: ->(u) { u.member_id.present? }

  belongs_to :member, optional: true

  after_create :update_member_email
  
  def membership_id=(val)
    @membership_id = val
  end

  def birthdate=(val)
    @birthdate = val
  end

  private

  def valid_member
    self.member = Member.valid_for_signup(@membership_id, @birthdate).first
    errors.add(:membership_id, "Não foi possível registrar usuário para este membro. Entre em contato com seu responsável.") if self.member.blank?
  end

  def update_member_email
    self.member.update(email: email) if self.member.present?
  end
end
