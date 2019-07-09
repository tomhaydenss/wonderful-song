FactoryBot.define do
  factory :leadership do
    member { create(:member) }
    position { create(:position) }
    appointment_date { Faker::Date.between(1.days.ago, 20.years.ago) }
    ensemble { create(:ensemble) }
    primary { true }
  end
end