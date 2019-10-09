class AddMemberToUser < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :member, foreign_key: true, index: true, optional: true
  end
end
