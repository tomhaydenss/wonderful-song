class Leadership < ApplicationRecord
  belongs_to :ensemble
  belongs_to :member
  belongs_to :position
end
