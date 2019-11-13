# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StringUtils do
  describe '#digits_only' do
    let(:string_with_number) { '0abc123def456ghi789' }

    subject { DummyClass.new.digits_only(string_with_number) }

    it { should eq('0123456789') }
  end
end

class DummyClass
  include StringUtils
end
