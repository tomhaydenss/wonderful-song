# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Address, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:postal_code) }
    it { should validate_presence_of(:neighborhood) }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:state) }
    it { should validate_presence_of(:street) }
    it { should validate_presence_of(:number) }

    it { should_not allow_value('12345678').for(:postal_code) }
    it { should allow_value('12345-678').for(:postal_code) }

    context 'when an address already exists for the member' do
      let(:member) { build(:member, :with_address) }
      let(:address) { member.addresses.first }

      subject { Address.new(postal_code: address.postal_code, member_id: member.id) }

      before { member.save }

      it { should validate_uniqueness_of(:postal_code).scoped_to(:member_id).case_insensitive }
    end
  end
end
