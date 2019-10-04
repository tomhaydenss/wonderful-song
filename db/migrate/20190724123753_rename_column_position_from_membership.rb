class RenameColumnPositionFromMembership < ActiveRecord::Migration[5.2]
  def up
    rename_column :memberships, :position, :organizational_position
  end

  def down
    rename_column :memberships, :organizational_position, :position
  end
end
