# frozen_string_literal: true

class LeaderRole < ApplicationRecord
  belongs_to :position
  belongs_to :leader
end
