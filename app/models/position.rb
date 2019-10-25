# frozen_string_literal: true

class Position < ApplicationRecord
  validates :description, presence: true
  validates :description, uniqueness: { case_sensitive: false }
end
