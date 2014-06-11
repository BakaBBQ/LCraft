=begin
the purpose of world provider is to have a class handle all the worldgen
and this class can be loaded from other files...

therefore creating custom worldgen files
=end


=begin
procedure to generate the world
x = WorldProvider.new(world_obj)
x.main
=end
class WorldProvider
  def initialize(world)
    @world = world
  end
  
  def main
    generate_world
  end
  
  def generate_world
  end
  
  def chunk_provide(x,y)
  end
end