# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CustomLink, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:alias) }
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:url) }

    context 'when a record with the same alias already exists' do
      let(:previous_custom_link) { create(:custom_link) }

      subject { CustomLink.new(alias: previous_custom_link.alias.swapcase) }

      it { should validate_uniqueness_of(:alias).case_insensitive }
    end
  end
end
