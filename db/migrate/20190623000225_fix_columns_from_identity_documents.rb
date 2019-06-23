class FixColumnsFromIdentityDocuments < ActiveRecord::Migration[5.2]
  def change
    change_column :identity_documents, :number, :string, limit: 25
    change_column :identity_documents, :complement, :string, limit: 25
  end
end
