class CreatePositions < ActiveRecord::Migration[5.2]
  def change
    create_table :positions do |t|
      t.string :description, limit: 100, null: false

      t.timestamps
    end
  end
end
