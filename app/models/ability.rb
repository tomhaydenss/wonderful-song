# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    if user.present?
      if user.has_position? 'admin'
        can :create, Position
      end
    end
  end
end
