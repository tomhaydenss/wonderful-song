class PhoneType < ApplicationRecord
    scope :mobile, -> { where(description: 'Celular').first }
    scope :home, -> { where(description: 'Residencial').first }
  end
