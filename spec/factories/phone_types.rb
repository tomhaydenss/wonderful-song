# frozen_string_literal: true

FactoryBot.define do
  PHONE_TYPES = %w[Celular Residencial Trabalho].freeze
  factory :phone_type do
    description { PHONE_TYPES.sample }
  end
end
