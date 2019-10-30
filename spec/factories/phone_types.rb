# frozen_string_literal: true

FactoryBot.define do
  PHONE_TYPES = %w[mobile home work].freeze
  factory :phone_type do
    description { PHONE_TYPES.sample }
  end
end
