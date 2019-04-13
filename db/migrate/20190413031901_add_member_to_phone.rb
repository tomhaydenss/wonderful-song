class AddMemberToPhone < ActiveRecord::Migration[5.2]
  def change
    add_reference :phones, :member, foreign_key: true, index: true, null: false
  end
end
