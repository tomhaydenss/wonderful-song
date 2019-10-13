module NameFormatter
  extend ActiveSupport::Concern

  def format_name(name)
    return name if name.blank?

    name.split.each { |name| %w[da das do dos de del di e el y la].include?(name.downcase) ? name.downcase! : name.capitalize! }.join(' ')
  end
end
