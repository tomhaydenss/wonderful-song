# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MembersHelper do
  describe '.members_as_grouped_options' do
    let(:ensemble) { create(:ensemble) }
    let(:members) { create_list(:member, rand(2..3), ensemble: ensemble) }

    subject { MembersHelper.members_as_grouped_options(members) }

    it { should eq(expected_result) }
  end

  private

  def expected_result
    [[ensemble.name, members_result]]
  end

  def members_result
    members.map { |member| [member.name, member.id] }
  end
end
