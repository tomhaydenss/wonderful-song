# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IdentityDocumentType, type: :model do
  describe 'validations' do
    context 'when a description is not given' do
      it { should validate_presence_of(:description) }
    end

    context 'when a record with the same description already exists' do
      let(:previous_identity_document_type) { create(:identity_document_type) }

      subject { IdentityDocumentType.new(description: previous_identity_document_type.description.swapcase) }

      it { should validate_uniqueness_of(:description).case_insensitive }
    end
  end

  context 'pre-fixed types' do
    describe '#tax_payer?' do
      let(:identity_document_type) { create(:identity_document_type, description: 'CPF') }

      subject { identity_document_type.tax_payer? }

      it { should be_truthy }
    end

    describe '#id?' do
      let(:identity_document_type) { create(:identity_document_type, description: 'RG') }

      subject { identity_document_type.id? }

      it { should be_truthy }
    end

    describe '#birth_certificate?' do
      let(:identity_document_type) { create(:identity_document_type, description: 'Certidão de Nascimento') }

      subject { identity_document_type.birth_certificate? }

      it { should be_truthy }
    end
  end
end
