class Game_Actor
  def backpack
    bk = BackPack.new
    bk.materials = Array.new(10){$data_materials[:cloth]}
    bk.owner = self
    @backpack ||= bk
  end
end