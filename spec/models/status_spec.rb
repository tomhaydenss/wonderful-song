# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Status, type: :model do
  describe 'validations' do
    context 'when a description is not given' do
      it { should validate_presence_of(:description) }
    end

    context 'when a record with the same description already exists' do
      let(:previous_status) { create(:status) }

      subject { Status.new(description: previous_status.description.swapcase) }

      it { should validate_uniqueness_of(:description).case_insensitive }
    end
  end
end
