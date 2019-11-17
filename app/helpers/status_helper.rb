# frozen_string_literal: true

module StatusHelper
  def self.status_available(current_user)
    current_user.any_roles?(%i[main_leader admin]) ? Status.all : Status.reversible_only
  end
end
