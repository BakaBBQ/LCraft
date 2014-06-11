module DescriptionUtils
  def vocab_for_using(difference)
    # >0 means bigger
    # <0 means smaller
    r = case difference
    when -5..5
      "Seems like it fits you very well"
    when 6..10
      "A Little bit bigger but still fit quite well"
    when 11..15
      "Maybe too big, still usable"
    when 16..20
      "Quite big for your size, maybe you can try?"
    end
  end
  
  def vocab_for_size(size)
    size_for_comp = (size / 10).to_i
    table = [
      'XXXXS',
      'XXXS',
      'XXS',
      'XS',
      'S',
      'M-',
      'M',
      'M+',
      'L',
      'XL',
      'XXL',
      'XXXL',
      'XXXXL',
    ]
    return table[size_for_comp]
  end
end

class Window
  include DescriptionUtils
end