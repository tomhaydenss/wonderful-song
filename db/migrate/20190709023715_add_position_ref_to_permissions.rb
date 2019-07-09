class AddPositionRefToPermissions < ActiveRecord::Migration[5.2]
  def change
    add_reference :permissions, :position, foreign_key: true
  end
end
