# frozen_string_literal: true

FactoryBot.define do
  factory :partial_membership_row, class: Hash do
    membership_id { { 'Cód. Membro': build(:membership_id) } }
    name { { 'Nome': Faker::Name.name } }
    birthdate { { 'Nascimento': Faker::Date.in_date_period.strftime('%d/%m/%Y') } }
    joining_date { { 'Conversão': Faker::Date.in_date_period.strftime('%d/%m/%Y') } }
    bsp_subscription { { 'BSP': build(:bit_boolean) } }
    tc_subscription { { 'TC': build(:bit_boolean) } }
    r10_subscription { { 'R10': build(:bit_boolean) } }
    division { { 'Divisão': build(:division) } }
    organizational_information { { 'Organização': build(:organizational_information_partial_version) } }
    organizational_positions { { 'Funções': build(:organizational_positions_partial_version) } }
    sustaining_contribution { { 'Kofu': build(:yes_no) } }
    study_level { { 'Grau Budismo': Faker::Educator.degree } }
    email { { 'E-mail': Faker::Internet.email } }
    home_phone { { 'Tel. Res.': Faker::PhoneNumber.phone_number } }
    work_phone { { 'Tel. Com.': Faker::PhoneNumber.phone_number } }
    mobile_phone { { 'Celular': Faker::PhoneNumber.cell_phone } }

    trait :without_positions do
      organizational_positions { { 'Funções': '-' } }
    end

    trait :without_birthdate do
      birthdate { { 'Nascimento': 'não informado' } }
    end

    trait :without_joining_date do
      birthdate { { 'Conversão': 'não informado' } }
    end

    initialize_with do
      attributes.values.inject({}) { |hash, item| hash.merge(item) }.stringify_keys
    end
  end

  factory :organizational_information_partial_version, class: String do
    organizations do
      build_list(:organization_level, 5, :valid).inject([]) { |array, item| array << "#{item[:level]} #{item[:name].upcase}" }
    end

    initialize_with { new(organizations.join(' / ')) }
  end

  factory :organizational_positions_partial_version, class: String do
    positions do
      organizations = build(:organizational_information_partial_version).split(' / ')
      positions_quantity = rand(1..3)
      build(:organizational_positions, quantity: positions_quantity).values.first.each_with_index.inject([]) do |array, (item, index)|
        array << "#{item[:position]} #{item[:division]} (#{organizations[index]})"
      end.join(' / ')
    end

    initialize_with { new(positions) }
  end

  factory :full_membership_row, class: Hash do
    membership_id { { 'Cód. Membro': build(:membership_id) } }
    name { { 'Nome': Faker::Name.name } }
    joining_date { { 'Conversão': Faker::Date.in_date_period.strftime('%d/%m/%Y') } }
    bsp_subscription { { 'BSP': build(:bit_boolean) } }
    tc_subscription { { 'TC': build(:bit_boolean) } }
    r10_subscription { { 'R10': build(:bit_boolean) } }
    organizational_information { { 'Organização': build(:organizational_information_full_version) } }
    organizational_position { { 'Função': Faker::Military.army_rank } }
    sustaining_contribution { { 'Kofu': build(:bit_boolean) } }
    study_level { { 'Grau Budismo': Faker::Educator.degree } }
    members_sponsored { { 'Shakubukus': build(:members_sponsored).to_s } }
    discussion_meeting { { 'Última RP': build(:discussion_meeting_full_version) } }

    trait :without_joining_date do
      birthdate { { 'Conversão': 'N/A' } }
    end

    trait :without_positions do
      organizational_position { { 'Função': 'N/A' } }
    end

    trait :without_discussion_meeting do
      birthdate { { 'Última RP': 'N/A' } }
    end

    initialize_with do
      attributes.values.inject({}) { |hash, item| hash.merge(item) }.stringify_keys
    end
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

  factory :discussion_meeting_full_version, class: String do
    last_attendance do
      meeting = ['Reunião de Palestra', 'BVD', 'Convenção da Vitória'].freeze.sample
      date = Faker::Date.in_date_period.strftime('%m/%Y')
      organization = build(:organization).upcase
      "#{meeting} (#{date}) > #{organization}"
    end

    initialize_with { new(last_attendance) }
  end
end
