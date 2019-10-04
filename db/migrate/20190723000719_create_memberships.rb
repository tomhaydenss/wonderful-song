class CreateMemberships < ActiveRecord::Migration[5.2]
  def up
    create_table :memberships, id: false do |t|
      t.integer :id, null: false
      t.string :name, limit: 100
      t.date :joining_date
      t.string :position, limit: 50
      t.string :study_level, limit: 50
      t.boolean :sustaining_contribution, default: false
      t.jsonb :discussion_meeting, null: false, default: {}
      t.jsonb :publications_subscriptions, null: false, default: {}
      t.jsonb :members_sponsored, null: false, default: {}
      t.jsonb :organizational_information, null: false, default: {}

      t.timestamps
    end
    execute "ALTER TABLE memberships ADD PRIMARY KEY (id);"
  end

  def down
    drop_table :memberships
  end
end
