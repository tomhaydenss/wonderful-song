# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MembershipParserFactory do
  describe '.for' do
    subject { MembershipParserFactory.for(headers) }

    context 'when is a membership file with full attributes' do
      let(:headers) { { 'Última RP': '', 'Shakubukus': '' }.stringify_keys }

      it { expect(subject).to be_a_kind_of(FullMembershipParser) }
    end

    context 'when is a membership file with few attributes' do
      let(:headers) { {} }

      it { expect(subject).to be_a_kind_of(PartialMembershipParser) }
    end
  end
end
