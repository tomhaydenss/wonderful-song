class AddStatusToMember < ActiveRecord::Migration[5.2]
  def change
    add_reference :members, :status, foreign_key: true, index: true, optional: true
  end
end
