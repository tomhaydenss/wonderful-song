class AddBasicIndexes < ActiveRecord::Migration[5.2]
  def change
    add_index :phones, :phone_number
    add_index :phone_types, :description
    add_index :identity_documents, :number
    add_index :identity_document_types, :description
    add_index :ensembles, :name
    add_index :members, :name
  end
end
