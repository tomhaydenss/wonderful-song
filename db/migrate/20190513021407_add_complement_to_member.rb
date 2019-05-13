class AddComplementToMember < ActiveRecord::Migration[5.2]
  def change
    add_column :members, :complement, :string
  end
end
