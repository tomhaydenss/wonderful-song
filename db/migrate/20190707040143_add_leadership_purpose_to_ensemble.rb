class AddLeadershipPurposeToEnsemble < ActiveRecord::Migration[5.2]
  def change
    add_column :ensembles, :leadership_purpose, :boolean
  end
end
