# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PartialMembershipParser do
  describe '#parse' do
    let(:row) { build(:partial_membership_row) }

    subject { PartialMembershipParser.new.parse(row) }

    it { expect(subject.name).to eq(row['Nome']) }
    it { expect(subject.joining_date.strftime('%d/%m/%Y')).to eq(row['Conversão']) }
    it { expect(subject.birthdate.strftime('%d/%m/%Y')).to eq(row['Nascimento']) }
    it { expect(subject.sustaining_contribution).to eq(row['Kofu'] == 'sim') }
    it { expect(subject.study_level).to eq(row['Grau Budismo']) }
    it { expect(subject.email).to eq(row['E-mail']) }
    it { expect(subject.phones['phones'][0]).to eq(row['Tel. Res.']) }
    it { expect(subject.phones['phones'][1]).to eq(row['Tel. Com.']) }
    it { expect(subject.phones['phones'][2]).to eq(row['Celular']) }

    context 'with organizational information' do
      let(:organizations_stored) do
        subject.organizational_information['organizations'].inject([]) do |array, item|
          array << "#{item['level']} #{item['name']}"
        end
      end
      let(:organizations_splited) { row['Organização'].split(' / ') }

      it { expect(organizations_stored).to eq(organizations_splited) }
    end

    context 'with organizational positions' do
      let(:positions_stored) do
        subject.organizational_positions['positions'].inject([]) do |array, item|
          array << "#{item['position']} #{item['division']}"
        end
      end
      let(:positions_splited) { row['Funções'].split(' / ').map { |item| item.split(' (').first } }

      it { expect(positions_stored).to eq(positions_splited) }
    end

    context 'without organizational positions' do
      let(:row) { build(:partial_membership_row, :without_positions) }

      it { expect(subject.organizational_positions).to be_empty }
    end
  end
end
