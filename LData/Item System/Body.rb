class Game_Battler
  attr_accessor :body # now the body determines everything
  def body
    bd = HumanBody.new unless @body
    bd =  PredefinedBodies.normal unless @body
    @body ||= bd
  end
end



class Body
  attr_accessor :main_size # the size for generating the whole body size
  attr_accessor :parts
  def initialize
    super
    @main_size = 65
  end
  
  def main_size
    return @main_size.to_f
  end
  
  
  def gen(size)
    @main_size = size
    BodyParser.parse @parts
    pts = BodyParser.result
    pts.collect{|pt| pt.part}.each do |p|
      p.size = size + rand(10) - 5
    end
    @main_size = pts.collect{|pt| pt.part.size}.average
    puts @main_size
  end
end

module Kernel
  def hash_retreiver(hash)
    return hash if hash.is_a? Array
    result = []
    result += hash.keys
    hash.values.each do |v|
      result += hash_retreiver(v)
    end
    return result
  end
end


class HumanBody < Body
  def initialize
    super
    #(hand arm foot leg head neck upperbody eye ear nose)
    @parts = {
          Upperbody.new => {
            Neck.new => {
              Head.new => [
                Eye.new,
                Eye.new,
                Ear.new,
                Ear.new,
                Nose.new
              ]
            },
            
            Arm.new => [
              Hand.new
            ],
            
            Arm.new => [
              Hand.new
            ],
          },
          
          Lowerbody.new => {
            Leg.new => [
              Foot.new
            ],
            
            Leg.new => [
              Foot.new
            ],
          },
    }
    
    
    t  = Time.now
    puts '======================='
  BodyParser.start(@parts)
  @parsedbody = BodyParser.result
    puts '======================='
    
    puts Time.now - t
  end
end

#~ HumanBody.new