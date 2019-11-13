# frozen_string_literal: true

class Leader < ApplicationRecord
  belongs_to :ensemble
  belongs_to :member
  has_many :leader_roles, dependent: :delete_all
  has_many :positions, through: :leader_roles

  accepts_nested_attributes_for :leader_roles, reject_if: :all_blank, allow_destroy: true

  def positions
    leader_roles.includes(:position).order('positions.precedence_order').map(&:position).map(&:description).join(' + ')
  end

  def positions_complements
    leader_roles.includes(:position).order('positions.precedence_order').map(&:additional_information).reject(&:blank?).join(' + ')
  end
end
