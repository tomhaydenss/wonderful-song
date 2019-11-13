# frozen_string_literal: true

FactoryBot.define do
  factory :ensemble_level do
    description { build(:level) }

    trait :top_level do
      precedence_order { 0 }
    end
  end
end
