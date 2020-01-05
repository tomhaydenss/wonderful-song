# frozen_string_literal: true

class Phone < ApplicationRecord
  belongs_to :phone_type

  validates :phone_number, presence: true
  validates :phone_number, format: { with: /\A[(][0-9]{2}[)] [9]?[0-9]{4}-[0-9]{4}\z/ }
  validates :phone_number, uniqueness: { scope: :member_id }

  def inline_description
    "#{phone_type.description}: #{phone_number}#{" [#{additional_information}]" if additional_information.present?}"
  end
end
