class HpGauge < Sprite
  attr_accessor :owner
  MAX_LENGTH = 32
  def initialize(owner,vp=nil)
    super(vp)
    self.visible = false
    @owner = owner
    self.bitmap = Bitmap.new(32,5)
    @ori_hp = :meow
    refresh
  end
  
  def refresh
    return if disposed?
    self.bitmap.clear
    self.bitmap.fill_all(Color.new(0,0,0))
#~     red_rect = Rect.new(1,1,31,4)
    max_length = 30.0
    cur_length = max_length * (current_hp.to_f / max_hp).to_f
    red_rect = Rect.new(1,1, cur_length, 3)
    bitmap.fill_rect(red_rect, color_to_use)
    if self.owner.erased
      self.visible = false
      self.dispose
    end
    
  end
  
  def color_to_use
    return Color.new(0,180,0) if owner.unit == $game_player.unit
    return Color.new(255,180,0)
    return Color.new(220,20,60)
  end
  
  
  def max_hp
    return owner.mhp
  end
  
  def current_hp
    return owner.hp
  end
  
  
  def update
    return if self.disposed?
    super
    
    self.x = owner.screen_x - 16
    self.y = owner.screen_y - 42
    self.visible = ! self.owner.erased
    refresh if @ori_hp != owner.hp
    @ori_hp  = owner.hp
  end
  
end
