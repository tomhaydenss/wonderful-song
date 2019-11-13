# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CPFValidator do
  describe '#cpf_valid?' do
    subject { CPFValidator.new.cpf_valid?(cpf_number) }

    context 'when valid' do
      let(:cpf_number) { Faker::IDNumber.brazilian_citizen_number }
      it { should be_truthy }
    end

    context 'when invalid' do
      let(:cpf_number) { Faker::IDNumber.invalid_south_african_id_number }
      it { should be_falsey }
    end
  end
end
