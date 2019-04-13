class CreateEmails < ActiveRecord::Migration[5.2]
  def change
    create_table :emails do |t|
      t.string :email_address, limit: 100, null: false
      t.boolean :primary

      t.timestamps
    end
  end
end
