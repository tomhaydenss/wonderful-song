class ImprovePositionColumn < ActiveRecord::Migration[5.2]
  def change
    remove_column :memberships, :organizational_position
    add_column :memberships, :organizational_positions, :jsonb, null: false, default: {}
  end
end
