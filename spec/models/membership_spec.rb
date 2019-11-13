# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Membership, type: :model do
  describe '.by_id' do
    let(:membership_id) { build(:membership_id) }

    before { create(:membership, id: membership_id) }

    subject { Membership.by_id(membership_id).first }

    it { expect(subject.id).to eq(membership_id) }
  end

  describe '.autocomplete' do
    let(:name) { Faker::Name.name }
    let(:first_letters_downcase) { name.split.map { |part| part.chars.first.downcase }.join(' ') }

    before { create(:membership, name: name) }

    subject { Membership.autocomplete(first_letters_downcase).first }

    it { expect(subject.name).to eq(name) }
  end

  describe '#name' do
    context 'when a member\'s name has a wrong case' do
      let(:membership) { build(:membership, name: name.swapcase) }
      let(:name) { 'João da Silva Penteado' }

      subject { membership.name }

      it { expect(subject).to eq(name) }
    end
  end

  describe '#autocomplete_label' do
    let(:membership) { build(:membership) }

    subject { membership.autocomplete_label }

    it { expect(subject).to eq("#{membership.id} - #{membership.name} (#{membership.fully_qualified_organization_name})") }
  end

  describe '#subscribed_to_publications?' do
    subject { membership.subscribed_to_publications? }

    context 'member without subscription' do
      let(:membership) { build(:membership, :without_subscriptions) }

      it { is_expected.to be_falsey }
    end

    context 'member with at least one subscription' do
      let(:membership) { build(:membership, :with_at_least_one_subscription) }

      it { is_expected.to be_truthy }
    end
  end

  describe '#attended_to_last_meeting?' do
    let(:membership) { build(:membership, discussion_meeting: discussion_meeting) }
    let(:discussion_meeting) { build(:discussion_meeting, last_attendance: last_attendance) }
    let(:last_attendance) { build(:last_attendance, date: date) }

    subject { membership.attended_to_last_meeting? }

    context 'member has attended to last meeting' do
      let(:date) { Faker::Date.between(from: 1.month.ago.end_of_month, to: 1.month.ago.end_of_month).strftime('%F') }

      it { is_expected.to be_truthy }
    end

    context 'member hasn\'t attended to last meeting' do
      let(:date) { Faker::Date.between(from: 1.year.ago, to: 2.months.ago.end_of_month).strftime('%F') }

      it { is_expected.to be_falsey }
    end

    context 'member has never attended to a meeting' do
      let(:last_attendance) {}

      it { is_expected.to be_falsey }
    end
  end

  describe '#fully_qualified_organization_name' do
    let(:membership) { build(:membership) }

    subject { membership.fully_qualified_organization_name }

    it do
      organizations = membership.organizational_information['organizations']
      fully_qualified_organization_name = organizations.map { |item| "#{item['level']} #{item['name']}" }.join(' » ')
      should eq(fully_qualified_organization_name)
    end
  end

  describe '#organizational_position' do
    let(:membership) { build(:membership, organizational_positions: organizational_positions) }

    subject { membership.organizational_position }

    context 'member has no organizational position' do
      let(:organizational_positions) { {} }

      it { should eq('') }
    end

    context 'member has one or more organizational position' do
      let(:organizational_positions) { build(:organizational_positions, quantity: rand(1..3)) }

      it { should eq(organizational_positions[:positions].map { |item| item[:position] }.join(' / ')) }
    end
  end
end
