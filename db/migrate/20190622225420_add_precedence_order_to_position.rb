class AddPrecedenceOrderToPosition < ActiveRecord::Migration[5.2]
  def change
    add_column :positions, :precedence_order, :integer
  end
end
