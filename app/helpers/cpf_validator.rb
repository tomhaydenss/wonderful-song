# frozen_string_literal: true

class CPFValidator
  class << self
    def cpf_valid?(cpf)
      return false if cpf.length != 11 || sequenced?(cpf)

      first_digit = evaluate_digit(cpf[0..-3]).to_s
      second_digit = evaluate_digit(cpf[0..-2]).to_s
      cpf[-2] == first_digit && cpf[-1] == second_digit
    end

    private

    def sequenced?(cpf)
      (0..9).inject([]) { |array, i| array << ''.ljust(11, i.to_s) }.include?(cpf)
    end

    def evaluate_digit(digits)
      digit = sum_of_digits(digits) * 10 % 11
      digit < 10 ? digit : 0
    end

    def sum_of_digits(digits)
      digits.chars.each_with_index.inject(0) { |sum, item| sum + item.first.to_i * (digits.length + 1 - item.last) }
    end
  end
end
