module BodyParser
  
end

ParsedPart = Struct.new(:parent, :part) do
  def indent
    return 0 if self.parent.nil?
    return 1 + self.parent.indent
  end
end

class << BodyParser
  attr_reader :result
  def start(hash)
    @result = []
    parse hash
  end
  def parse(hash, parent = nil)
    if hash.is_a? Array
      @result += hash.collect{|h| ParsedPart.new(parent, h)}
      return
    end
    hash.each do |k, v|
      cur_p = ParsedPart.new(parent,k)
#~       puts "===="
#~       puts cur_p
#~       puts "===="
      @result << ParsedPart.new(parent, k)
      if v.is_a? Array
        parse(v, cur_p)
      else
        v.each_value do |value|
          parse(v,cur_p)
        end
      end
      
    end
    
    @result.uniq!
  end
end

HumanBody.new