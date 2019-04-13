class CreateAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :addresses do |t|
      t.string :cep, limit: 8, null: false
      t.string :address, limit: 255, null: false
      t.string :neighborhood, limit: 255, null: false
      t.string :city, limit: 255, null: false
      t.string :state, limit: 2, null: false
      t.boolean :primary

      t.timestamps
    end
  end
end
