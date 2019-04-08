class CreateMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :members do |t|
      t.string :name
      t.date :joining_date
      t.date :birthdate
      t.string :identity_document
      t.string :cpf
      t.string :food_restrictions

      t.timestamps
    end
  end
end
