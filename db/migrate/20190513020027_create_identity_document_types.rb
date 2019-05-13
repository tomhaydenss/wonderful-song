class CreateIdentityDocumentTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :identity_document_types do |t|
      t.string :description

      t.timestamps
    end
  end
end
