# frozen_string_literal: true

FactoryBot.define do
  AVAILABLE_OPERATORS = ['Claro', 'Surf Telecom', 'Vivo', 'TIM', 'Net', 'Embratel', 'Oi', 'Nextel', 'Sercomtel'].freeze

  factory :phone do
    phone_number { Faker::PhoneNumber.phone_number }
    phone_type { build(:phone_type) }
    additional_information { build(:phone_operator) }
  end

  factory :phone_operator, class: String do
    operator { AVAILABLE_OPERATORS.sample }

    initialize_with { new(operator) }
  end
end
