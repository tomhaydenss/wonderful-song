module StringUtils

  protected

  def digits_only(number)
    number.scan(/\d/).join('')
  end
end