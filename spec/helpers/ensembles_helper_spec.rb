# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EnsembleHelper do
  describe '.ensembles_as_grouped_options' do
    let(:ensemble_level) { create(:ensemble_level) }
    let(:ensemble_parent) { create(:ensemble, :for_leadership_purpose, ensemble_level: ensemble_level) }
    let(:ensembles) do
      create_list(:ensemble, rand(2..3), :for_membership_purpose, ensemble_parent: ensemble_parent, ensemble_level: ensemble_level)
    end
    let(:expected_result) { [[ensemble_parent.name, ensembles_result]] }
    let(:ensembles_result) { ensembles.map { |ensemble| [ensemble.name, ensemble.id] } }

    subject { EnsembleHelper.ensembles_as_grouped_options(ensembles) }

    it { should eq(expected_result) }
  end
end
