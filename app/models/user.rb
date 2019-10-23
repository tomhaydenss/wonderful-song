class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  attr_reader :membership_id, :birthdate

  validates :membership_id, :birthdate, presence: true
  validate :valid_member
  validates :member_id, uniqueness: true, if: ->(u) { u.member_id.present? }

  belongs_to :member, optional: true

  after_create :update_member_email
  after_find :initialize_roles
  
  def membership_id=(val)
    @membership_id = val
  end

  def birthdate=(val)
    @birthdate = val
  end

  def any_roles? (roles)
    (@roles & roles).present?
  end
  
  private
  
  def valid_member
    self.member = Member.valid_for_signup(@membership_id, @birthdate).first
    errors.add(:membership_id, "Não foi possível registrar usuário para este membro. Entre em contato com seu responsável.") if self.member.blank?
  end
  
  def update_member_email
    self.member.update(email: email) if self.member.present?
  end
  
  def initialize_roles
    # TODO should be replaced by authorization feature
    @roles ||= [:member, :leader, :main_leader, :admin] if admin?
    @roles ||= [:member, :leader, :main_leader] if @roles.blank? && main_leader?
    @roles ||= [:member, :leader] if @roles.blank? && leader?
    @roles ||= [:member] if @roles.blank? && member?
  end    

  def member?
    self.member.leader_roles.empty?
  end
  
  def leader?
    ensemble = self.member.highest_ensemble_level_through_leadership
    return false if ensemble.blank?
    
    ensemble.ensemble_level.precedence_order > 0
  end
  
  def main_leader?
    ensemble = self.member.highest_ensemble_level_through_leadership
    return false if ensemble.blank?
    
    ensemble.ensemble_level.precedence_order == 0
  end
  
  def admin?
    self.email == 'admin'
  end
end