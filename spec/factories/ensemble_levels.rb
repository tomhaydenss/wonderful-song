# frozen_string_literal: true

FactoryBot.define do
  factory :ensemble_level do
    description { build(:level) }
  end
end
