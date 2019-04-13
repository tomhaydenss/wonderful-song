class CreatePhones < ActiveRecord::Migration[5.2]
  def change
    create_table :phones do |t|
      t.string :phone_number, limit: 20, null: false
      t.references :phone_type, foreign_key: true, index: true, null: false

      t.timestamps
    end
  end
end
