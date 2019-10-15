class CPFValidator
  def self.cpf_valid?(cpf)
    return false if cpf.length != 11 || is_sequenced?(cpf)
    first_digit = evaluate_digit(cpf[0..-3]).to_s
    second_digit = evaluate_digit(cpf[0..-2]).to_s
    cpf[-2] == first_digit && cpf[-1] == second_digit
  end

  private

  def self.is_sequenced?(cpf)
    (0..9).inject([]) { |array, i| array << ''.ljust(11, i.to_s) }.include?(cpf)
  end

  def self.evaluate_digit(digits)
    sum_of_digits(digits) * 10 % 11
  end
  
  def self.sum_of_digits(digits)
    digits.chars.each_with_index.inject(0) { |sum, item| sum += item.first.to_i * (digits.length+1-item.last) }
  end
end  