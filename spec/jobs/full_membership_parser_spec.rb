# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FullMembershipParser do
  describe '#parse' do
    let(:row) { build(:full_membership_row) }

    subject { FullMembershipParser.new.parse(row) }

    it { expect(subject.id).to eq(row['Cód. Membro']) }
    it { expect(subject.name).to eq(row['Nome']) }
    it { expect(subject.joining_date.strftime('%d/%m/%Y')).to eq(row['Conversão']) }
    it { expect(subject.sustaining_contribution).to eq(row['Kofu'] == '1') }
    it { expect(subject.study_level).to eq(row['Grau Budismo']) }
    it { expect(subject.members_sponsored['total']).to eq(row['Shakubukus'].to_i) }

    context 'without joining date' do
      let(:row) { build(:full_membership_row, :without_joining_date) }

      it { expect(subject.joining_date).to be_nil }
    end

    context 'without organizational positions' do
      let(:row) { build(:full_membership_row, :without_positions) }

      it { expect(subject.organizational_positions).to be_empty }
    end

    context 'without discussion meeting' do
      let(:row) { build(:full_membership_row, :without_discussion_meeting) }

      it { expect(subject.discussion_meeting).to be_empty }
    end

    context 'with organizational information' do
      let(:organizations_stored) do
        subject.organizational_information['organizations'].inject([]) do |array, item|
          array << "#{item['level']} #{item['name']}"
        end
      end
      let(:organizations_splited) do
        row['Organização'].split(';')[1..-1].map do |item|
          item.split(' (').first
        end
      end

      it { expect(organizations_stored).to eq(organizations_splited) }
    end

    context 'with organizational positions' do
      let(:positions_stored) do
        subject.organizational_positions['positions'].first['position']
      end
      let(:positions_splited) { row['Função'] }

      it { expect(positions_stored).to eq(positions_splited) }
    end
  end
end
