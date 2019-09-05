module EnsembleHelper
  def self.ensembles_as_grouped_options(ensembles)
    hash = {}
    ensembles.each do |ensemble|
      key = ensemble.ensemble_parent.fully_qualified_name
      value = [ensemble.name, ensemble.id]
      if hash[key].present?
        hash[key] << value
      else
        hash[key] = [value]
      end
    end
    hash.to_a
  end
end
