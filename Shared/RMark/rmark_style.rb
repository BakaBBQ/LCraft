module RMark::Style
  HASHTAG_SIZE_INCREMENT = 10
  CALC_SIZE = lambda do |hash_cnt|
    return Font.default_size if hash_cnt == 0
    return Font.default_size + (5 - hash_cnt) * 8
  end
  
end