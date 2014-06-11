







class TileGen
  class << self
    SEA  = 2048
    LAND = 2816
    LAKE = 2432
    MOUNTAIN = 3198
    MOUNT = MOUNTAIN
    HILL = 3150
    SEAHILL = 2144
    LOW = 2912
    GRASS = 2864
    def gen
      t = Time.now
      @map = MapData.new(200,200)
      gen_ocean
      gen_land
      gen_washing
      #map.data = @map.pack
      data = @map.pack
      data.normalize_all
      puts "Finished! Time: #{Time.now - t} sec"
      return data
    end
    
    def layer1
      @map.layer1
    end
    
    def layer2
      @map.layer2
    end
    
    def layer3
      @map.layer3
    end
    
    def layer4
      @map.layer4
    end
    
    def gen_ocean
      layer1.xsize.times  do |x|
        layer1.ysize.times  do |y|
          layer1[x, y] = 2048
        end
      end
      
    end
    
    def gen_land
      rows = layer1.xsize
      cols = layer1.ysize
      game = GameOfLife.new rows,cols
      game.randomize
      game.next_state
      game.next_state
      
      layer1.xsize.times do |x|
        layer1.ysize.times do |y|
          v = game.grid[x][y] == 0 ? 2048 : 2816
          layer1[x,y] = v
          layer2[x,y] = 2096 if v == 2048
        end
      end
      gen_shallow_water
      gen_lakes
      gen_terrain
      differ_biome
      gen_forest
      #normalize
    end
    
    SNOWLAND = 3968
    SNOWHILL = 4016
    SNOWMOUNT = 4304
    def differ_biome
      tpmap = TemperatureMap.new(@heightmap)
      layer1.each_coord do |x,y|
        if tpmap[x,y] <= 10
          convert_to_ice(x,y)
        end
      end
    end
    
      
      def convert_to_ice x, y
        layer1[x,y] = SNOWLAND if layer1[x,y] == LAND
        layer2[x,y] = 0 if layer2[x,y] == GRASS
        layer2[x,y] = SNOWHILL if layer2[x,y] == HILL
        layer2[x,y] = SNOWMOUNT if layer2[x,y] == MOUNT
      end
    
    
    def normalize
      #layer1 = Normalizer.normalize(layer1,0)
      t = Time.now
      layer_spec = layer1
      result = Table.new(layer_spec.xsize, layer_spec.ysize, 3)
      layer_spec.each_coord do |x,y|
        result.set_autotile(x,y,0,layer_spec[x,y], {:update_surround => false})
      end
      #result.normalize_all
      layer1 = result.flatten_xy(0)
      @map.layer1 = layer1
      
      layer_spec = layer2
      result = Table.new(layer_spec.xsize, layer_spec.ysize, 3)
      layer_spec.each_coord do |x,y|
        
        result.set_autotile(x,y,0,layer_spec[x,y], {:update_surround => false})
      end
      
      #result.
      #normalize_all
      layer2 = result.flatten_xy(0)
      @map.layer2 = layer2
      puts "Normalize - Time Cost #{Time.now - t}"
    end
    
    
    def gen_lakes
      layer1.each_coord do |x,y|
        deal_with_lake(x,y) if layer1[x,y] == SEA
      end
    end
    
    def gen_terrain
      @heightmap = HeightMap.new(200, 200)
      @heightmap.generate(10)
      grid = @heightmap.get_grid()
      grid.each_with_index do |row,y|
        row.each_with_index do |height, x|
          deal_with_te(x,y,height)
        end
      end
    end
  
     
     
       
    def deal_with_te(x,y,height)
      case layer1[x,y]
      when SEA
        if height >= 4
          layer2[x,y] = SEAHILL
        end
      
      when LAND
        if height >=1
          layer2[x,y] = HILL if height <=2
          layer2[x,y] = MOUNT if height > 2
        end
        
        if height <= -1
          layer2[x,y] = GRASS
        end
      end
    end
    
    TREE_PINE = 3056
    TREE_NORMAL = 3008
    def gen_forest
      @rainmap = RainMap.new(@heightmap)
      layer2.each_coord do |x,y|
        next unless (layer1[x,y] == LAND || layer1[x,y] == LOW)
        layer2[x,y] = TREE_NORMAL if rand < 0.2
      end
    end
    
    
    
    
    
      

#~ def get_height_color(height)
#~     value = (10 * height) + 127
#~     if value > 255 then
#~       value = 255
#~     elsif value < 0 then
#~       value = 0
#~     end
#~     if height >= 0 then
#~       #puts "this is the value #{value}"
#~       return Color.new(0, value, 0, 255)
#~     else
#~       
#~       return Color.new(0, 0, value, 255)
#~     end
#~   end
#~ @grid.each_with_index() do |row, y|
#~         row.each_with_index do |height, x|
#~           draw_square(self, x * @tile_width, y * @tile_height, 1, @tile_width, @tile_height, get_height_color(height))
#~         end
#~       end
  #  end
    
    
    def gen_shallow_water
      layer1.each_coord do |x,y|
        fill_neibours_with_shallow(x,y) if layer1[x,y] == LAND
      end
      
      #layer1.each_coord
    end
    
    
    def neibours(x,y)
      cnt = 0
      [
      [x + 1, y],
        [x - 1, y],
        [x, y + 1],
        [x, y - 1],
        [x + 1, y + 1],
        [x + 1, y - 1],
        [x - 1, y + 1],
        [x - 1, y - 1]
      ].each do |c|
        next unless layer1[c[0],c[1]]
        if layer1[c[0],c[1]] == 2816
          cnt += 1
        end
      end
      return cnt
    end
    
    def fill_neibours_with_shallow(x,y)
      
        #if layer1[x,] == LAND
          [-1,0,1,].each do |j|
            [-1,0,1].each do |k|
              layer2[j + x,k + y] = 0 #if layer2[j + x,k + y] == 2096
            end
          end
        
        #end
      end
      
    def deal_with_lake(x,y) # use when you know x,y is shallow water
      
      cnt = 0
      [-1,0,1].each do |j|
        [-1,0,1].each do |k|
          cnt += 1 if layer1[j + x,k + y] == LAND
        end
      end
      
      if cnt >= 6
        layer1[x,y] = LAKE
      end
      
    end
#~       coords.each do |c|
#~         layer1[c[0], c[1]] = 2816 if rand(5) == 0
#~       end

    
    
    def gen_washing
    end
    
  end
  
end