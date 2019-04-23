class CreateLeaderships < ActiveRecord::Migration[5.2]
  def change
    create_table :leaderships do |t|
      t.date :appointment_date
      t.boolean :primary
      t.references :ensemble, foreign_key: true, index: true, null: false
      t.references :member, foreign_key: true, index: true, null: false
      t.references :position, foreign_key: true, index: true, null: false
      
      t.timestamps
    end
  end
end
