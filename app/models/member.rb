class Member < ApplicationRecord
  include Filterable

  validates :name, :membership_id, presence: true
  
  belongs_to :membership, optional: true
  belongs_to :ensemble, optional: true
  has_many :phones, dependent: :delete_all
  has_many :addresses, dependent: :delete_all
  has_many :identity_documents, dependent: :delete_all
  has_many :leaders
  has_many :leader_roles, through: :leaders
  has_one_attached :csv_file

  scope :ensemble_id, ->(ensemble_id) { where('ensemble_id = ?', ensemble_id) }
  scope :search, ->(search) { where('name ILIKE ?', "%#{search}%") }

  accepts_nested_attributes_for :identity_documents, :phones, :addresses, :reject_if => :all_blank, :allow_destroy => true

  def highest_ensemble_level_through_leadership
    leaders.select { |leader| leader.ensemble.ensemble_level.precedence_order.present? }
          .sort_by { |leader| leader.ensemble.ensemble_level.precedence_order }.first.ensemble
  end
end
