FactoryBot.define do
  factory :ensemble do
    name { Faker::Address.city }
    ensemble_level { create(:ensemble_level) }
  end
end