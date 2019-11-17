# frozen_string_literal: true

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

  attr_writer :membership_id

  attr_writer :birthdate

  def any_roles?(roles)
    (@roles & roles).present?
  end

  def active_for_authentication?
    admin? || (member.status.present? && !member.status.block_access?)
  end

  def member?
    member.leader_roles.empty?
  end

  def leader?
    ensemble = member.highest_ensemble_level_through_leadership
    return false if ensemble.blank?

    ensemble.ensemble_level.precedence_order.positive?
  end

  def main_leader?
    ensemble = member.highest_ensemble_level_through_leadership
    return false if ensemble.blank?

    ensemble.ensemble_level.precedence_order.zero?
  end

  def admin?
    email == 'admin'
  end

  private

  def valid_member
    self.member = Member.valid_for_signup(@membership_id, @birthdate).first
    return unless member.blank?

    errors.add(:membership_id, 'Não foi possível registrar usuário para este membro. Entre em contato com seu responsável.')
  end

  def update_member_email
    member.update(email: email) if member.present?
  end

  def initialize_roles
    # TODO: should be replaced by authorization feature
    if admin?
      @roles = %i[member leader main_leader admin]
    elsif main_leader?
      @roles = %i[member leader main_leader]
    elsif leader?
      @roles = %i[member leader]
    elsif member?
      @roles = [:member]
    end
  end
end
