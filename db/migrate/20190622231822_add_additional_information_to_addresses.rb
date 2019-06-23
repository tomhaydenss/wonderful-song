class AddAdditionalInformationToAddresses < ActiveRecord::Migration[5.2]
  def change
    add_column :addresses, :additional_information, :string, limit: 100
  end
end
