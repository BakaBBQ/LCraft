module BitmapUtils
  def fill_all(color)
    self.fill_rect(0,0,width,height,color)
  end
end

class Bitmap
  include BitmapUtils
end
