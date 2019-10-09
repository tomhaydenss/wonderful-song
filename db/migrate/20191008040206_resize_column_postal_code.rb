class ResizeColumnPostalCode < ActiveRecord::Migration[5.2]
  def up
    change_column :addresses, :postal_code, :string, limit: 9
  end

  def down
    change_column :addresses, :postal_code, :string, limit: 8
  end
end
