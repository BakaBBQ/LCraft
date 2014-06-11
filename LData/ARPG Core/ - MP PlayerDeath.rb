Game_Player = Class.new Game_Player.clone do
  def update
    super
    if self.battler.hp <= 0 
      SceneManager.call(Scene_Gameover) # cruel world, isn't it
    end
#    self.battler.mp_obj.update
end
  def method_missing(a,*b,&c)
    battler.send a, *b, &c
  end
  
end
