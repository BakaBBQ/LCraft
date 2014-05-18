module RMark::Window
  def cursor
    @cursor = RMark::Cursor.new unless @cursor
    return @cursor
  end
    
  def write(text, hash_cnt)
    size_change = RMark::Style::CALC_SIZE.call(hash_cnt)
    text_array = text_warpper text
    size_cleanroom(size_change) do 
      text_array.each do |t|
        smart_draw(cursor.x,cursor.y,t)
        move_cursor(t)
      end
    end
  end
  
  def size_cleanroom(new_size = nil)
    ori_size = Marshal.load(Marshal.dump(contents.font.size))
    contents.font.size = new_size if new_size
    yield
    contents.font.size = ori_size
  end
  
  def move_cursor(text)
    cursor.y += contents.text_size(text).height
  end
  
  def smart_draw(x,y,text,alignment = 0)
    s = contents.text_size text
    draw_text(x,y,contents.width,s.height,text,alignment)
  end

  
  def text_warpper(text)
    my_width = contents.width
    text_width = contents.text_size(text).width
    return [text] unless text_width > my_width # if the text is good, let it go
    # if not, try to warp it
    return process_warp(text)
  end
  
  def process_warp(text) # used within text_warpper
    results = []
    
    tmp_string = ''
    words = text.split(" ")
    words.each do |w|
      if true_width(tmp_string + "#{w} ") > contents.width
        results << "#{tmp_string} "
        tmp_string = "#{w} "
      else
        tmp_string += "#{w} "
      end
      
    end # each
    results << tmp_string
    return results
  end
  
  def true_width(text)
    return text_size(text).width
  end
  
  def get_width(object)
    return text_width object if object.is_a?(String)
    return bitmap_width object if object.is_a?(Bitmap)
  end
  
  def bitmap_width bitmap
    return bitmap.width
  end
  
  def text_width(text)
    return text_size(text).width
  end
  
  def draw_parsedtext(parsedtext)
    parsedtext.each do |l|
      
    end
  end
  
  
  def try_draw(obj)
    cleanroom do
      ldraw_richtext obj if obj.is_a?(RichText)
      ldraw_bitmap obj if obj.is_a?(Bitmap)
    end
  end
  
  def ldraw_richtext
  end
  
  def ldraw_bitmap
  end
  
  
  def draw_richtext(obj)
    
  end
  
  def cleanroom
    ori_font = Marshal.load(Marshal.dump(contents.font))
    yield
    contents.font = ori_font
  end
end


class Window_Base
  include RMark::Window
end
