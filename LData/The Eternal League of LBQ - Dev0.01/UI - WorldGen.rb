class Scene_WorldGen < Scene_Base
  def start
    super
    @bg = Plane.new
    @bg.bitmap = Cache.parallax "Mountains4"
    @sp_ime = SpriteIME.new
    @canvas = Sprite.new
    @canvas.z = 100
    @canvas.bitmap = Bitmap.new Graphics.width, Graphics.height
    t = "Type the name and left-click to generate"
    @canvas.bitmap.draw_text(0,0,Graphics.width,Graphics.height,t)
  end
  
  def terminate
    super
    @sp_ime.dispose
  end
  
  def update
    super
    @sp_ime.update
  end
end
