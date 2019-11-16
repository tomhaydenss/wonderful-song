class CreateStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :statuses do |t|
      t.string :description
      t.boolean :statistic_purpose
      t.boolean :reversible
      t.boolean :block_access

      t.timestamps
    end
  end
end
