class CreateIdentityDocuments < ActiveRecord::Migration[5.2]
  def change
    create_table :identity_documents do |t|
      t.string :number
      t.string :complement
      t.references :identity_document_type, foreign_key: true

      t.timestamps
    end
  end
end
