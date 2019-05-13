class AddMemberToIdentityDocument < ActiveRecord::Migration[5.2]
  def change
    add_reference :identity_documents, :member, foreign_key: true, index: true, null: false
  end
end
