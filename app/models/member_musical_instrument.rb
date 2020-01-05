# frozen_string_literal: true

class MemberMusicalInstrument < ApplicationRecord
  belongs_to :member
  belongs_to :musical_instrument

  accepts_nested_attributes_for :musical_instrument, reject_if: :all_blank
end
