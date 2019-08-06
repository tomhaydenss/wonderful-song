class Member < ApplicationRecord
  include Filterable
  
  belongs_to :membership, optional: true
  belongs_to :ensemble, optional: true
  has_many :phones, dependent: :delete_all
  has_many :addresses, dependent: :delete_all
  has_many :identity_documents, dependent: :delete_all
  has_many :leaders
  has_many :leader_roles, through: :leaders

  scope :ensemble_id, ->(ensemble_id) { where('ensemble_id = ?', ensemble_id) }

  accepts_nested_attributes_for :identity_documents, :phones, :addresses, :reject_if => :all_blank, :allow_destroy => true

  def highest_ensemble_level_through_leadership
    leaders.select { |leader| leader.ensemble.ensemble_level.precedence_order.present? }
          .sort_by { |leader| leader.ensemble.ensemble_level.precedence_order }.first.ensemble
  end
end
