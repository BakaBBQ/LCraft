#-------------------------------------------------------------------------
# 用来显示输入法拼音的小窗
#-------------------------------------------------------------------------
class WindowComposition < Sprite_Base
  def initialize(viewport = nil)
    super(viewport)
    self.bitmap = Bitmap.new(128, 36)
    self.bitmap.font.size = Integer(Font.default_size * 1.3)
    @temp = ""
    self.clear
  end
  def refresh(str)
    return if disposed?
    word_length = self.bitmap.text_size(str).width + 16
    self.bitmap.dispose unless self.bitmap.disposed?
    self.bitmap = Bitmap.new(word_length, 36)
    return if word_length == 16
    self.bitmap.fill_rect(0, 0, word_length, 36, Color.new(137, 135, 135))
    self.bitmap.fill_rect(1, 1, word_length - 2, 34, Color.new(0, 0, 0, 196))
    self.bitmap.draw_text(5, 0 ,word_length - 8, 36, str)
    self.visible = true
  end
  def clear
    self.visible = false
  end
end
#-------------------------------------------------------------------------
# 用来显示输入法备选文字的小窗
#-------------------------------------------------------------------------
class WindowCanList < Sprite_Base
  def initialize(viewport = nil)
    super(viewport)
    @item_max = 0
    @temp = []
    self.bitmap = Bitmap.new(1,1)
    self.bitmap.font.size = Integer(Font.default_size * 1.2)
    self.clear
  end
  def check_size(list)
    @item_max = list.size
    max_height = (list.size * 28)
    max_height = max_height == 0 ? 1 : max_height
    max_width = 0
    for str in list
      if max_width < self.bitmap.text_size(str).width
        max_width = self.bitmap.text_size(str).width
      end
    end
    self.bitmap.dispose unless self.bitmap.nil? or self.bitmap.disposed?
    return if disposed?
    self.bitmap = Bitmap.new( max_width + 32 , max_height)
    self.bitmap.font.size = Integer(Font.default_size * 1.3)
  end
  def refresh(list)
    check_size(list)
    return if disposed?
    return self.clear if self.height == 1
    self.bitmap.clear
    self.bitmap.fill_rect(0, 0, self.bitmap.width, self.bitmap.height, Color.new(137, 135, 135))
    self.bitmap.fill_rect(1, 1, self.bitmap.width - 2, self.bitmap.height - 2, Color.new(0, 0, 0, 196))
    for i in 0...list.size
      self.bitmap.draw_text(6, i * 28 , 240, 28, "#{i+1}.#{list[i]}")
    end
    self.visible = true
  end
  def clear
    self.visible = false
  end
end
#-------------------------------------------------------------------------
# 已输入的文字内容
#-------------------------------------------------------------------------
class WindowChar < Sprite_Base
  attr_reader :lest_x
  attr_reader :words
  def initialize(viewport = nil)
    super(viewport)
    self.bitmap = Bitmap.new(210, 32)
    self.bitmap.font.size = Integer(Font.default_size * 1.2)
    @chars = []
    @pos = 0
    @lest_x = 0
    @str_save = ""
    self.x = 110
    self.y = 255
    @input_phase = "name"
    refresh_cursor(@pos)
  end
  def refresh
    self.bitmap.clear
    @lest_x = 0
    i = 0
    for str in @chars
      if @input_phase == "password"
        i += 1
        next if @chars.size - i >= 9
        id = @chars.index(str) % 8
        self.bitmap.blt(@lest_x, 0, Cache.system("password"), Rect.new(id * 20, 0, 20, 20))
        @lest_x += 20
        @lest_x = 180 if @lest_x >= 180
      else
        self.bitmap.draw_text(@lest_x, 0, 320, 32, str)
        @lest_x += self.bitmap.text_size(str).width
      end
    end
  end
  # 输入的内容
  def words
    temp_string = ""
    for str in @chars do temp_string += str end
    return temp_string
  end
  def update
    str=$game_ime.char
    if(str != "") && str != "\010"
      self.add(str)
    end
  end
  def add(str)
    @chars.insert(@pos, str)
    refresh
    right
  end
  def pop
    @chars.delete_at(@pos-1)
    refresh
    left
  end
  def refresh_cursor(pos)
    str = @chars[0...pos]
    x = 0
    for i in 0...str.size
      if @input_phase == "password"
        x += 20
        x = 180 if x >= 180
      else
        x += self.bitmap.text_size(str[i]).width
      end
    end
    #self.cursor_rect.set(x, 0, 2, 24)
    self.bitmap.fill_rect(x, 0, 2, 32, Color.new(255, 255, 255))
  end
  def pos_refresh(val)
    @pos += val
    @pos = 0 if @pos < 0
    @pos = @chars.size if @pos > @chars.size
    refresh_cursor(@pos)
  end
  def left
    pos_refresh(-1)
  end
  def right
    pos_refresh(1)
  end
  # 干挺所有内容
  def clear_contents
    @chars = []
    @pos = 0
    @lest_x = 0
    @str_save = ""
    refresh
    refresh_cursor(@pos)
  end
  # 设置类型
  def set_phase(phase)
    @input_phase = phase
  end
end
#-------------------------------------------------------------------------
# 用来显示当前是什么输入法，放在右下角，布局已经完毕。可以耍花样
#-------------------------------------------------------------------------
class Window_Description < Sprite_Base
  def initialize(viewport = nil)
    super(viewport)
    self.bitmap = Bitmap.new(490, 45)
    self.bitmap.font.size = Integer(Font.default_size * 1.2)
    self.x = 150
    self.y = 406
    @temp = "\000"
    self.clear
  end
  def refresh(des)
    if des == "\000"
      @temp = des
      self.clear 
      return 
    end
    return if @temp == des
    @temp = des
    srf_string = "当前输入法：" + des
    word_width = self.bitmap.text_size(srf_string).width + 48
    left_x = self.bitmap.width - word_width
    self.bitmap.clear
    self.bitmap.fill_rect(left_x, 0, word_width, 45, Color.new(137, 135, 135))
    self.bitmap.fill_rect(left_x + 1, 1, word_width - 2, 43, Color.new(0, 0, 0, 196))
    self.bitmap.draw_text(left_x, 0, word_width - 24, 45, srf_string, 2)
    self.visible = true
  end
  def clear
    self.visible = false unless disposed?
  end
end
class SpriteIME
  # 包含API声明
  include FSL::Conf::WndProc::Win_API
  # 包含消息常数
  include FSL::Conf::WndProc::WM_MSG
  attr_accessor :now_phase
  def initialize(viewport=nil)
    Mouse.stop
    WndProc.init
    $game_ime = GameIME.new if $game_ime == nil
    Mouse.start
    @char_list = []
    @now_phase = "name"
    create_window
    
    # 设置Proc
    message_proc = Proc.new do |hWnd, message, wParam, lParam| 
      self.pop_message(hWnd, message, wParam, lParam) 
    end
    # 申请响应
    WndProc.reg_back_msg(WM_KEYDOWN, message_proc)
    
    @refresh_need = false
  end
  def pop_message(hWnd, message, wParam, lParam)
    case message
    when WM_KEYDOWN
      case wParam
      when 8
        @char_window.pop
      when 37
        @char_window.left
      when 39
        @char_window.right
      end
    end
  end 
  def create_window
    @des_window  = Window_Description.new($viewport1)
    @comp_window = WindowComposition.new($viewport1)
    @char_window = WindowChar.new($viewport1)
    @list_window = WindowCanList.new($viewport1)
    @des_window.z = 190
    @comp_window.z = 200
    @char_window.z = 200
    @list_window.z = 200
  end
  def set_pos(x, y)
    return if @comp_window.disposed?
    @comp_window.x = x
    @comp_window.y = y
    @list_window.x = x + @comp_window.width + 4
    @list_window.y = [y, 480 - @list_window.bitmap.height].min
  end
  def update
    return if @now_phase == "nothing"
    @des_window.refresh($game_ime.description)
    @char_window.update
    if $game_ime.now_str != "\000"
      @comp_window.refresh($game_ime.now_str)
      @list_window.refresh($game_ime.can_list)
      @refresh_need = false
      set_pos(137 + @char_window.lest_x, 287)
    else
      @comp_window.clear
      @list_window.clear
    end
  end
  def dispose
    @des_window.dispose
    @comp_window.dispose
    @list_window.dispose
    @char_window.dispose
    Mouse.restart
  end
  # 获得当前输入的内容
  def get_words
    return @char_window.words
  end
  # 更改阶段
  def change_now_phase(new_phase)
    return if new_phase == @now_phase
    @now_phase = new_phase
    @comp_window.clear
    @char_window.clear_contents
    @char_window.set_phase(new_phase)
    @list_window.clear
    case @now_phase
    when "name"
      @char_window.y = 255
      @char_window.visible = true
    when "password"
      @char_window.y = 255 + 47
      @char_window.visible = true
    when "nothing"
      @char_window.visible = false
    end
  end
end