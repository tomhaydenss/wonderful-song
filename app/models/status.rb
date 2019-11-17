# frozen_string_literal: true

class Status < ApplicationRecord
  validates :description, presence: true
  validates :description, uniqueness: { case_sensitive: false }

  scope :statistic_purpose_only, -> { where(statistic_purpose: true) }
  scope :reversible_only, -> { where(reversible: true) }
end
