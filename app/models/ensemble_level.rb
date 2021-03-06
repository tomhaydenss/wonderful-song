# frozen_string_literal: true

class EnsembleLevel < ApplicationRecord
  validates :description, presence: true
  validates :description, uniqueness: { case_sensitive: false }
end
