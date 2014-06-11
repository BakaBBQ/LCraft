class Chunk
  attr_accessor :map_table
  attr_accessor :biome
  
  attr_accessor :flag
=begin
flags:
[:after_biome],
[:after_lakes],
=end
  def setup
    @map_table = Table.new(200,200,3)
    @flag = {}
  end
end