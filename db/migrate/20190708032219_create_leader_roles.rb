class CreateLeaderRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :leader_roles do |t|
      t.string :additional_information, limit: 100
      t.boolean :primary
      t.references :position, foreign_key: true, index: true, null: false
      t.references :leader, foreign_key: true, index: true, null: false

      t.timestamps
    end
  end
end
