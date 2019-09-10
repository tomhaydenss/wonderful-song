class AddNewColumnsToMembership < ActiveRecord::Migration[5.2]
  def change
    add_column :memberships, :birthdate, :date
    add_column :memberships, :email, :string, limit: 100
    add_column :memberships, :phones, :jsonb, null: false, default: {}
  end
end
