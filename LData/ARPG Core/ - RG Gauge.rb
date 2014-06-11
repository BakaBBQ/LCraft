Spriteset_Map = Class.new Spriteset_Map.clone do
  def create_characters
    super
    
    create_gauges
  end
  
  def create_gauges
    @gauges = []
    $game_map.battlers.each do |b|
      @gauges << HpGauge.new(b,@viewport3)
    end
  end
  
  def update
    super
    @gauges.each do |g|
      @gauges.delete g if g.disposed?
      g.update
    end
  end
  
  def refresh_gauges
    @gauges.each do |g|
      g.refresh
    end
  end
end
