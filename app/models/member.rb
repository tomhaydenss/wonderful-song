# frozen_string_literal: true

class Member < ApplicationRecord
  include Filterable
  include NameFormatter

  validates :name, :membership_id, presence: true
  validate :member_cannot_be_associated_with_another_ensemble
  validates :membership_id, uniqueness: true, if: ->(m) { m.membership_id.present? }

  belongs_to :membership, optional: true
  belongs_to :ensemble, optional: true
  has_one :user
  has_many :phones, dependent: :delete_all
  has_many :addresses, dependent: :delete_all
  has_many :identity_documents, dependent: :delete_all
  has_many :leaders
  has_many :leader_roles, through: :leaders
  has_one_attached :csv_file

  scope :ensemble_id, ->(ensemble_id) { where('ensemble_id = ?', ensemble_id) }
  scope :search, ->(search) { where('immutable_unaccent(name) ILIKE ?', "%#{search.split.join('%')}%") }
  scope :autocomplete, ->(term, limit = 10) { search(term).limit(limit) }
  scope :valid_for_signup, lambda { |membership_id, birthdate|
    where(membership_id: membership_id, birthdate: birthdate).where.not(ensemble_id: nil)
  }
  scope :permitted_ensembles_only, ->(ensembles) { where(ensemble_id: ensembles).includes(:ensemble) }
  scope :by_membership_id, ->(membership_id) { where(membership_id: membership_id).includes(:ensemble) }

  accepts_nested_attributes_for :identity_documents, :phones, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :addresses, allow_destroy: true

  def name=(val)
    write_attribute(:name, format_name(val))
  end

  def highest_ensemble_level_through_leadership
    leaders.select { |leader| leader.ensemble.ensemble_level.precedence_order.present? }
           .min_by { |leader| leader.ensemble.ensemble_level.precedence_order }&.ensemble
  end

  def positions
    leaders.each_with_object([]) { |leader, array| array << "#{leader.positions} (#{leader.ensemble.name})"; }.join(' / ')
  end

  private

  def member_cannot_be_associated_with_another_ensemble
    member = member_already_associated
    return if member.blank? || member.ensemble.blank?

    errors.add(:membership_id, "Membro já associado com o núcleo #{member.ensemble.fully_qualified_name}")
  end

  def member_already_associated
    return if membership_id.blank?

    Member.by_membership_id(membership_id).reject { |m| m.id == id }.first
  end
end
