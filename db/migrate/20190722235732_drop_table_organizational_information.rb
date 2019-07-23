class DropTableOrganizationalInformation < ActiveRecord::Migration[5.2]
  def change
    remove_index :members, name: 'index_members_on_organizational_information_id'
    remove_column :members, :organizational_information_id
    drop_table :organizational_informations
  end
end
