class FixColumnNameCepFromAddressToPostalCode < ActiveRecord::Migration[5.2]
  def change
    rename_column :addresses, :cep, :postal_code
  end
end
