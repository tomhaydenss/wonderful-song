# frozen_string_literal: true

class PhoneType < ApplicationRecord
  validates :description, presence: true
  validates :description, uniqueness: { case_sensitive: false }

  scope :mobile, -> { where(description: 'Celular').first }
  scope :home, -> { where(description: 'Residencial').first }
end
