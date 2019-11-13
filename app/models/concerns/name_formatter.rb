# frozen_string_literal: true

module NameFormatter
  extend ActiveSupport::Concern

  def format_name(name)
    return name if name.blank?

    name.split.each { |item| %w[da das do dos de del di e el y la].include?(item.downcase) ? item.downcase! : item.capitalize! }.join(' ')
  end
end
