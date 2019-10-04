class AddAdditionalInformationToPhones < ActiveRecord::Migration[5.2]
  def change
    add_column :phones, :additional_information, :string, limit: 100
  end
end
