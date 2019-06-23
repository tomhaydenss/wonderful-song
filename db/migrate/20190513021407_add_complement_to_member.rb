class AddComplementToMember < ActiveRecord::Migration[5.2]
  def change
    add_column :members, :complement, :string, limit: 255
  end
end
