# frozen_string_literal: true

class MusicalInstrument < ApplicationRecord
  validates :description, presence: true
  validates :description, uniqueness: { case_sensitive: false }

  has_many :member_musical_instruments, inverse_of: :tag
  has_many :members, through: :member_musical_instruments
end
