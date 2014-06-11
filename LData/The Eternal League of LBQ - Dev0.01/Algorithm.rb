class ColourPixel < Pixel
  def initialize(x, y, colour)
    @colour = colour
    super x, y
  end
  attr_accessor :colour
 
  def distance_to(px, py)
    Math::hypot(px - x, py - y)
  end 
end
 
width, height = 100, 100
npoints = 30
pixmap = Pixmap.new(width,height)
 
@bases = npoints.times.collect do |i|
  ColourPixel.new(
      3+rand(width-6), 3+rand(height-6),  # provide a margin to draw a circle
      RGBColour.new(rand(256), rand(256), rand(256))
  )
end
 
pixmap.each_pixel do |x, y| 
  nearest = @bases.min_by {|base| base.distance_to(x, y)}
  pixmap[x, y] = nearest.colour
end
 
@bases.each do |base| 
  pixmap[base.x, base.y] = RGBColour::BLACK
  pixmap.draw_circle(base, 2, RGBColour::BLACK)
end


#~ $lbq = Sprite.new
#~ $lbq.bitmap = pixmap.to_bitmap
#~ $lbq.z = 9999999
