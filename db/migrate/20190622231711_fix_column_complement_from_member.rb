class FixColumnComplementFromMember < ActiveRecord::Migration[5.2]
  def change
    rename_column :members, :complement, :additional_information
    change_column :members, :additional_information, :text
  end
end
