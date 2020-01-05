# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MusicalInstrument, type: :model do
  describe 'validations' do
    context 'when a description is not given' do
      it { should validate_presence_of(:description) }
    end

    context 'when a record with the same description already exists' do
      let(:previous_musical_instrument) { create(:musical_instrument) }

      subject { MusicalInstrument.new(description: previous_musical_instrument.description.swapcase) }

      it { should validate_uniqueness_of(:description).case_insensitive }
    end
  end
end
