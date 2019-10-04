class CreateLeaders < ActiveRecord::Migration[5.2]
  def change
    create_table :leaders do |t|
      t.date :appointment_date
      t.boolean :primary
      t.references :ensemble, foreign_key: true, index: true, null: false
      t.references :member, foreign_key: true, index: true, null: false

      t.timestamps
    end

    add_index :leaders, [:ensemble_id, :member_id], unique: true
  end
end
