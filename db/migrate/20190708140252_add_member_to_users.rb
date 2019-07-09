class AddMemberToUsers < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :member, foreign_key: true
  end
end
