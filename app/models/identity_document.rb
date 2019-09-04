class IdentityDocument < ApplicationRecord
  belongs_to :identity_document_type

  validates_uniqueness_of :number, scope: [:member_id]
end
