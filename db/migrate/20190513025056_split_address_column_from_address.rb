class SplitAddressColumnFromAddress < ActiveRecord::Migration[5.2]
  def change
    remove_column :addresses, :address, :string
    add_column :addresses, :street, :string, limit: 255, null: false
    add_column :addresses, :number, :string, limit: 10, null: false
  end
end
