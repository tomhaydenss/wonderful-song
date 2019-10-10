class Ensemble < ApplicationRecord
  include Filterable

  belongs_to :ensemble_level
  belongs_to :ensemble_parent, class_name: "Ensemble", optional: true
  has_many :ensembles, class_name: "Ensemble", foreign_key: "ensemble_parent_id"
  has_many :members
  has_many :leaders

  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }

  accepts_nested_attributes_for :leaders, reject_if: :all_blank, allow_destroy: true

  scope :leadership_purpose_only, -> { where(leadership_purpose: true) }
  scope :membership_purpose_only, -> { where(leadership_purpose: false) }
  scope :permitted_ensembles_only, ->(ensembles) { where(id: ensembles) }

  def fully_qualified_name
    return ensemble_parent.fully_qualified_name + ' » ' + name if ensemble_parent.present?
    name
  end

  def filterable_ensembles(include_parent_ensemble = false)
    return [] << self unless leadership_purpose
    
    array = []
    array << self if include_parent_ensemble
    ensembles.each do |ensemble|
      array << ensemble.filterable_ensembles(include_parent_ensemble)
    end
    array.flatten
  end
end
