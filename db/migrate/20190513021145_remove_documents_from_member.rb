class RemoveDocumentsFromMember < ActiveRecord::Migration[5.2]
  def change
    remove_column :members, :identity_document, :string
    remove_column :members, :cpf, :string
  end
end
