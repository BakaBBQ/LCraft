# erase itself if hp <=0
Game_Event = Class.new Game_Event.clone do
  attr_reader :event
  def update
    super
    if @battler.hp <= 0
      self.erase
    end
#    puts @battler.mp_obj
  end
  
  def method_missing(a,*b,&c)
    @battler.send a, *b, &c
  end
  
  
  
end
