# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MembersToCsv do
  EMPTY_LINE = ''

  describe '#to_csv' do
    let(:members) { build_list(:member, 1, :with_ensemble) }

    subject { DummyClass.new.to_csv(members) }

    it { should be_instance_of(String) }
    it { should eq(members_as_csv(members)) }
  end

  private

  def headers
    %w[nucleo
       codigo_membro nome email data_nascimento data_ingresso_grupo
       restricao_alimentar
       telefones
       informacoes_adicionais].freeze
  end

  def members_as_csv(members)
    lines_with_headers = [headers.join(',')]
    csv_lines = members.inject(lines_with_headers) do |lines, member|
      lines << member_as_csv(member)
    end
    csv_lines << EMPTY_LINE
    csv_lines.join("\n")
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def member_as_csv(member)
    info = []
    info << member.ensemble.name
    info << member.membership_id
    info << member.name
    info << member.email
    info << member.birthdate
    info << member.joining_date
    info << member.food_restrictions
    info << '""'
    info << ''
    info.join(',')
  end
end
# rubocop:enable Metrics/AbcSize
# rubocop:enable Metrics/MethodLength

class DummyClass
  include MembersToCsv
end
