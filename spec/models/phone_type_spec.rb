# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PhoneType, type: :model do
  describe 'validations' do
    context 'when a description is not given' do
      it { should validate_presence_of(:description) }
    end

    context 'when a record with the same description already exists' do
      let(:previous_phone_type) { create(:phone_type) }

      subject { PhoneType.new(description: previous_phone_type.description.swapcase) }

      it { should validate_uniqueness_of(:description).case_insensitive }
    end
  end

  context 'pre-fixed types' do
    before { create(:phone_type, description: description) }

    describe '.mobile' do
      let(:description) { 'Celular' }

      subject { PhoneType.mobile }

      it { expect(subject.description).to eq(description) }
    end

    describe '.home' do
      let(:description) { 'Residencial' }

      subject { PhoneType.home }

      it { expect(subject.description).to eq(description) }
    end
  end
end
