class CreateEnsembles < ActiveRecord::Migration[5.2]
  def change
    create_table :ensembles do |t|
      t.string :name, limit: 100, null: false
      t.date :foundation_date
      t.text :history
      t.references :ensemble_level, foreign_key: true, index: true, null: false
      t.references :ensemble_parent, foreign_key: {to_table: :ensembles}, index: true

      t.timestamps
    end
  end
end
