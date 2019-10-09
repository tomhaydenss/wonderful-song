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
  scope :search, ->(search) { where('name ILIKE ?', "%#{search}%") }
  scope :valid_for_signup, ->(membership_id, birthdate) { where(membership_id: membership_id, birthdate: birthdate).where.not(ensemble_id: nil) }

  accepts_nested_attributes_for :identity_documents, :phones, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :addresses, allow_destroy: true

  def name=(val)
    write_attribute(:name, format_name(val))
  end

  def highest_ensemble_level_through_leadership
    leaders.select { |leader| leader.ensemble.ensemble_level.precedence_order.present? }
          .sort_by { |leader| leader.ensemble.ensemble_level.precedence_order }.first.ensemble
  end

  def positions
    leaders.inject([]) { |array, leader| array << "#{leader.positions} (#{leader.ensemble.name})"; array }.join(' / ')
  end

  private

  def member_cannot_be_associated_with_another_ensemble
    return if membership_id.blank?
    member = Member.where(membership_id: membership_id).reject { |m| m.id == id }.first
    return if member.blank? || member.ensemble.blank?

    errors.add(:membership_id, "Membro já associado com o núcleo #{member.ensemble.fully_qualified_name}")
  end
end
