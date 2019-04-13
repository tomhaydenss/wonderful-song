class AddOrganizationalInformationToMember < ActiveRecord::Migration[5.2]
  def change
    add_reference :members, :organizational_information, index: true, foreign_key: true
  end
end
