# frozen_string_literal: true

FactoryBot.define do
  factory :membership do
    id { build(:membership_id) }
    name { Faker::Name.name }
    birthdate { Faker::Date.between(from: 36.years.ago, to: 4.years.ago).strftime('%F') }
    joining_date { Faker::Date.between(from: birthdate, to: 4.years.ago).strftime('%F') }
    study_level { Faker::Educator.degree }
    sustaining_contribution { build(:boolean) }
    discussion_meeting { build(:discussion_meeting) }
    publications_subscriptions { { 'tc': build(:boolean), 'bsp': build(:boolean), 'rdez': build(:boolean) } }
    members_sponsored { rand(0..10) }
    organizational_information { build(:organizational_information) }
    organizational_positions { build(:organizational_positions) }
    email { Faker::Internet.email }
    phones { build(:phones) }

    trait :without_subscriptions do
      publications_subscriptions { { 'tc': false, 'bsp': false, 'rdez': false } }
    end

    trait :with_at_least_one_subscription do
      publications_subscriptions { { 'tc': true, 'bsp': false, 'rdez': false } }
    end
  end

  factory :membership_id, class: Integer do
    id { (1..5).map { rand(0..9).to_s }.join.to_i }

    initialize_with { id }
  end

  factory :discussion_meeting, class: Hash do
    last_attendance { build(:last_attendance) }

    initialize_with { attributes }
  end

  factory :last_attendance, class: Hash do
    date { Faker::Date.between(from: 1.year.ago, to: 1.month.ago).strftime('%F') }
    type { ['Reunião de Palestra', 'BVD'].freeze.sample }
    organization { build(:organization) }

    initialize_with { attributes }
  end

  factory :boolean, class: TrueClass do
    initialize_with { [true, false].sample }
  end

  factory :bit_boolean, class: String do
    ZERO_ONE = %w[0 1].freeze

    initialize_with { new(ZERO_ONE.sample) }
  end

  factory :yes_no, class: String do
    YES_NO = %w[sim não].freeze

    initialize_with { new(YES_NO.sample.to_s) }
  end

  factory :division, class: String do
    division { 'DMJ' }

    trait :invalid do
      division { (1..3).map { rand(65..90).chr }.join }
    end

    initialize_with { new(division) }
  end

  factory :level, class: String do
    RANDOM_LEVELS = %w[National Territory Zone Region Chapter District].freeze
    VALID_LEVELS = ['Coor. Geral', 'Coor.', 'Sub.', 'RM/RE', 'Regional', 'Área', 'Distrito', 'Comunidade', 'Bloco'].freeze

    level { RANDOM_LEVELS.sample }

    trait :valid do
      level { VALID_LEVELS.sample }
    end

    initialize_with { new(level) }
  end

  factory :organization, class: String do
    organization { Faker::Address.city }

    initialize_with { new(organization) }
  end

  factory :organization_level, class: Hash do
    name { build(:organization) }
    level { build(:level) }

    trait :valid do
      level { build(:level, :valid) }
    end

    initialize_with { attributes }
  end

  factory :organizational_information, class: Array do
    organizations { build_list(:organization_level, 5, :valid) }

    initialize_with { attributes }
  end

  factory :organizational_information_full_version, class: String do
    organizations do
      list = build_list(:organization_level, 5, :valid).inject([]) do |array, item|
        array << "#{item[:level]} #{item[:name].upcase} (#{rand(1..999)})"
      end
      list.join(';')
    end

    initialize_with { new(organizations) }
  end

  factory :organizational_position, class: Hash do
    division { build(:division) }
    position { Faker::Military.army_rank }

    initialize_with { attributes }
  end

  factory :organizational_positions, class: Hash do
    quantity { rand(0..2) }
    positions { build_list(:organizational_position, quantity) }

    initialize_with { attributes.slice(:positions) }
  end

  factory :phones, class: Hash do
    phones do
      (0..(rand(3))).each_with_object([]) do |index, array|
        array << Faker::PhoneNumber.phone_number if index.positive?
      end
    end

    initialize_with { attributes }
  end
end
