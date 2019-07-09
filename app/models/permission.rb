class Permission < ApplicationRecord
  belongs_to :position

  ACTIONS = %w(read write).freeze
  SUBJECTS = %w(positions ensemble_levels ensembles members phone_types identity_document_types).freeze

  validates_presence_of :action, :subject
  validates_inclusion_of :action, in: ACTIONS
  validates_inclusion_of :subject, in: SUBJECTS
end