class DropLeadershipTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :leaderships
  end
end
