class Ensemble < ApplicationRecord
  belongs_to :ensemble_level
  belongs_to :ensemble_parent, class_name: "Ensemble", optional: true
  has_many :ensembles, class_name: "Ensemble", foreign_key: "ensemble_parent_id"
  has_many :members
  has_many :leaderships
end
