class AddEmailToMember < ActiveRecord::Migration[5.2]
  def change
    add_column :members, :email, :string, limit: 100
  end
end
