class Array
  
  def mode
    freq = inject(Hash.new(0)) { |h,v| h[v] += 1; h }
    max = freq.values.max                   # we're only interested in the key(s) with the highest frequency
    r = freq.select { |k, f| f == max }         # extract the keys that have the max frequency
    return r.values[0]
  end
  
  def median
    sorted = sort
    len = length
    median = len % 2 == 1 ? sorted[len/2] : (sorted[len/2 - 1] + sorted[len/2]).to_f / 2
    return median
  end
  
  def average
    inject(:+)/length
  end
  
  
end
