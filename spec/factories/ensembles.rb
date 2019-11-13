# frozen_string_literal: true

FactoryBot.define do
  factory :ensemble do
    name { Faker::Address.city }
    foundation_date { Faker::Date.between(from: 58.years.ago, to: 1.year.ago).strftime('%F') }
    ensemble_level { build(:ensemble_level) }
    leadership_purpose { build(:boolean) }

    trait :for_leadership_purpose do
      leadership_purpose { true }
    end

    trait :for_membership_purpose do
      leadership_purpose { false }
    end

    trait :with_ensemble_parent do
      ensemble_parent { build(:ensemble) }
    end
  end
end
