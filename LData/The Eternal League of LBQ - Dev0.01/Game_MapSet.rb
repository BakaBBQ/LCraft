class Game_MapSet
  def initialize(name,seed)
    @name = name
    @seed = seed
    # all map datas are in MapDatas
    @world = MapData.new(200,200,:worldmap)
    @tiles = Array.new(20){Array.new(20)}
    @tiles.each do |e|
      e.each do |f|
        f = MapData.new(200,200,:normalmap)
      end
    end
    puts @tiles[0][1]
#~     @houses = Table.new(20,20,20)
#~     @houses.each do |e|
#~       e = MapData.new(200,200,:house)
#~     end
    
#~     @dungeons = Table.new(20,20,20)
#~     @dungeons.each do |e|
#~       e = MapData.new(200,200,:dungeon)
#~     end
    
    begin
      load_world
    rescue
      save
    end
  end
  
  def name
    return @name
  end
  
  
  def save
#~     [tile_directory, house_directory, dungeon_direction].each do |d|
#~       FileUtils.mkdir_p d
#~     end
    FileUtils.mkdir world_directory rescue
    save_world
  end
  
  def world_directory
    "Worlds/#{name.capitalize}"
  end
  
  def get_world
    #@world.gen_if_not
    @world = WorldGen.gen unless @world.gen?
    @world.instance_eval{@generated = true}
    return @world
  end
  
  def get_tile(x,y)
    @tile[x][y] = TileGen.gen unless @world.instance_eval{@generated}
    @tile[x][y].instance_eval{@generated = true}
    return tiles[x,y]
  end

  
  def save_world
    save_data(@world, world_directory + "/world.dat")
    save_data(@tiles, world_directory + "/tiles.dat")
#~     save_data(@houses, world_directory + "houses.dat")
#~     save_data(@dungeons, world_directory + "dungeons.dat")
  end
  
  def load_world
    @world = load_data(world_directory + "/world.dat")
    @tiles = load_data(world_directory + "/tiles.dat")
#~     @houses = load_data(world_directory + "houses.dat")
#~     @dungeons = load_data(world_directory + "dungeons.dat")
  end
end