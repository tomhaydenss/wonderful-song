# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Phone, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:phone_number) }
    it { should_not allow_value('11 98888-7777').for(:phone_number) }
    it { should allow_values('(11) 98888-7777', '(11) 8888-7777').for(:phone_number) }

    context 'when a phone with the same number already exists for the member' do
      let(:member) { build(:member, :with_phone) }
      let(:phone) { member.phones.first }
      let(:phone_type) { phone.phone_type }

      subject { Phone.new(phone_number: phone.phone_number, phone_type: phone_type, member_id: member.id) }

      before { member.save }

      it { should validate_uniqueness_of(:phone_number).scoped_to(:member_id).case_insensitive }
    end
  end
end
