class ResizeColumnDescriptionFromStatus < ActiveRecord::Migration[5.2]
  def change
    change_column :statuses, :description, :string, limit: 100
  end
end
