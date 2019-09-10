class NameFormatter
  def self.format(name)
    name.split.each { |name| %w[da das do dos de del di e el y la].include?(name.downcase) ? name.downcase! : name.capitalize! }.join(' ')
  end
end
