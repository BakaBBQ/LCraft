class WorldManager
end

class << WorldManager
  def create(name, seed = Random.new_seed)
    FileUtils.mkdir_p "Worlds/#{name.capitalize}/Tiles"
    w = WorldGen.gen
    save_data(w,"Worlds/#{name.capitalize}/World.wrd")
  end
  
  def load(name)
    load_data("Worlds/#{name.capitalize}/World.wrd")
  end
end