class FixColumnDescriptionFromIdentityDocumentTypes < ActiveRecord::Migration[5.2]
  def change
    change_column :identity_document_types, :description, :string, limit: 25
  end
end
