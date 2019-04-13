class CreateMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :members do |t|
      t.string :name, limit: 100, null: false
      t.date :joining_date
      t.date :birthdate
      t.string :identity_document, limit: 255
      t.string :cpf, limit: 11
      t.string :food_restrictions, limit: 100

      t.timestamps
    end
  end
end
