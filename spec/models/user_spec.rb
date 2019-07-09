require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:member_id) }

  subject do
    leadership = create(:leadership, position: create(:position, description: 'admin'))
    create(:user, member: leadership.member)
  end

  describe '#can?' do
    it 'returns true if user has permission' do
      params = { action: Permission::ACTIONS.sample, subject: Permission::SUBJECTS.sample }
      subject.member.positions.last.permissions.create(params)
      expect(subject.can? params[:action], params[:subject]).to eq true
    end
  end
end