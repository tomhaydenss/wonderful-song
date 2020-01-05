class CreateCustomLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :custom_links do |t|
      t.string :alias, limit: 50, null: false
      t.string :title, limit: 100, null: false
      t.string :url, limit: 255, null: false

      t.timestamps
    end

    add_index :custom_links, [:alias], unique: true
  end
end
