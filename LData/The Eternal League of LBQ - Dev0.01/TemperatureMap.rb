class TemperatureMap
  def initialize(heightmap)
    @data = Table.new(200,200)
    @data.each_coord do |x,y|
      @data[x,y] = model_function(y)
    end
    
    @data.each_coord do |x,y|
      @data[x,y] - heightmap.get(x,y) * 10
    end
  end
  
  def model_function(x)
    r = 50*(Math.sin(Math::PI/100 * (x - 50))) + 50
    return r.to_i
  end
  
  def [](x,y)
    return @data[x,y]
  end
  
end