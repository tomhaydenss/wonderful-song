# frozen_string_literal: true

class CustomLink < ApplicationRecord
  validates :alias, :title, :url, presence: true
  validates :alias, uniqueness: { case_sensitive: false }
end
