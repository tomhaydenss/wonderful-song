class ResizeColumnIdentityNumber < ActiveRecord::Migration[5.2]
  def change
    change_column :identity_documents, :number, :string, limit: 100
  end
end
