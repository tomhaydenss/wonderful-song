# frozen_string_literal: true

module EnsembleHelper
  def self.ensembles_as_grouped_options(ensembles)
    ensembles.each_with_object({}) do |ensemble, hash|
      key = ensemble.ensemble_parent.fully_qualified_name
      value = [ensemble.name, ensemble.id]
      if hash[key].present?
        hash[key] << value
      else
        hash[key] = [value]
      end
    end.to_a
  end
end
