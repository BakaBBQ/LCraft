#===============================================================================
# Used for WorldGen and Game_MapSet
#===============================================================================

class MapData
  attr_accessor :layer1, :layer2, :layer3, :layer4
  attr_accessor :heightmap, :events
  def initialize(width,height, type = :worldmap)
    @type = type
    @generated = false
    if worldmap?
      @heightmap = HeightMap.new(width, height)
      @heightmap.generate 10
      
      @rainmap = RainMap.new(@heightmap)
    end
  
    
    ori_map = Table.new(width, height, 3)
    
    
    @layer1 = Table.new(ori_map.xsize, ori_map.ysize)
    @layer2 = Table.new(ori_map.xsize, ori_map.ysize)
    @layer3 = Table.new(ori_map.xsize, ori_map.ysize)
    @layer4 = Table.new(ori_map.xsize, ori_map.ysize)

    @events = {}
    ori_map.each_with_index do |e, x, y ,z|
      puts "@layer#{z + 1}"
      instance_variable_get("@layer#{z + 1}")[x,y] = e
    end
  end
  
  def worldmap?
    return @type == :worldmap
  end
  
  def gen?
    @generated
  end
  
  def gen_if_not
    unless gen?
      case @type
      when :worldmap
        ori_map = WorldGen.gen
      else
        ori_map = TileGen.gen
      end
      ori_map.each_with_index do |e, x, y ,z|
          puts "@layer#{z + 1}"
          instance_variable_get("@layer#{z + 1}")[x,y] = e
        end
      @generated = true
    end
  end
  
  def gen
    ori_map = WorldGen.gen
    ori_map.each_with_index do |e, x, y ,z|
          puts "@layer#{z + 1}"
          instance_variable_get("@layer#{z + 1}")[x,y] = e
        end
        
        
    puts @layer1[10,10]
  end
  
  
  def width
    return @layer1.xsize
  end
  
  def height
    return @layer1.ysize
  end
  
  
  def pack
    result_data = Table.new(@layer1.xsize, @layer1.ysize, 4)
    result_data.each_with_3index do |v, x, y, z|
      result_data[x,y,z] = instance_variable_get("@layer#{z + 1}")[x,y]
    end
    return result_data
  end
  
  alias :to_table :pack
end