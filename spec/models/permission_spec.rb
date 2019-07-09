require 'rails_helper'

RSpec.describe Permission, type: :model do
  it { is_expected.to belong_to(:position) }
  it { is_expected.to validate_presence_of(:action) }
  it { is_expected.to validate_presence_of(:subject) }
end