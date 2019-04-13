class CreateEnsembleLevels < ActiveRecord::Migration[5.2]
  def change
    create_table :ensemble_levels do |t|
      t.string :description, limit: 100, null: false
      t.integer :precedence_order

      t.timestamps
    end
  end
end
