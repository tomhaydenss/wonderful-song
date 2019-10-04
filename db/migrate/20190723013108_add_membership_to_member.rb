class AddMembershipToMember < ActiveRecord::Migration[5.2]
  def up
    add_reference :members, :membership, index: true, foreign_key: true
  end

  def down
    remove_index :members, name: 'index_members_on_membership_id'
    remove_column :members, :membership_id
  end
end
