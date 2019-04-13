class CreateOrganizationalInformations < ActiveRecord::Migration[5.2]
  def change
    create_table :organizational_informations do |t|
      t.string :associated_code, limit: 10, null: false
      t.date :convertion_date
      t.string :position, limit: 100
      t.string :study_level, limit: 100
      t.integer :conversions_made, default: 0
      t.boolean :discussion_meeting, default: false
      t.boolean :sustaining_contribution, default: false
      t.boolean :publications_subscription, default: false

      t.timestamps
    end
  end
end
