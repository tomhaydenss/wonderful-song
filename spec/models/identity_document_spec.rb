# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IdentityDocument, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:number) }

    context 'when identity document type is tax payer id' do
      let(:identity_document) { build(:identity_document, :tax_payer_id) }

      it { expect(identity_document).to allow_value(identity_document.number).for(:number) }
      it { expect(identity_document).not_to allow_values('1234', '99999999999').for(:number) }
    end

    context 'when identity document type is id' do
      let(:identity_document) { build(:identity_document, :id) }

      it { expect(identity_document).to validate_presence_of(:complement) }
      it { expect(identity_document).to allow_value(identity_document.number).for(:number) }
      it { expect(identity_document).not_to allow_values('123', 'ABC123').for(:number) }
    end

    context 'when an identity document already exists for the member' do
      let(:member) { build(:member, :with_identity_document) }
      let(:document) { member.identity_documents.first }
      let(:document_type) { document.identity_document_type }

      subject { IdentityDocument.new(number: document.number, identity_document_type: document_type, member_id: member.id) }

      before { member.save }

      it { should validate_uniqueness_of(:number).scoped_to(:member_id).case_insensitive }
    end
  end
end
