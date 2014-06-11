#===============================================================================
# ■  FSL 重载窗口过程
#    FSL WndProc
#-------------------------------------------------------------------------------
#    重载RGSS Player窗口的WindowProc
#    调用WndProc.init开始重载,不可多次调用!!
#-------------------------------------------------------------------------------
#    更新作者： 神思
#    许可协议： FSL
#    项目分类： XP | VX  -  系统加强
#    衍生关系： 
#    项目版本： 1.0.0718
#    建立日期： 2010年07月18日
#    最后更新： 2010年07月18日
#    引用网址： 
#===============================================================================
#    - 1.0.0718 （2010.07.18）
#      * 初始版本完成；
#===============================================================================



#-------------------------------------------------------------------------------
# ▼ 登记FSL
#-------------------------------------------------------------------------------
$fscript = {} if $fscript == nil
$fscript["WndProc"] = "1.0.0718"


#-------------------------------------------------------------------------------
# ▼ 通用配置模块
#-------------------------------------------------------------------------------
module FSL
  module Conf
    module WndProc
      module Win_API
        # 寻找窗口
        FindWindow = Win32API.new("user32", "FindWindow", "pp", "l")
        # 重置窗口过程
        ReSetProc = Win32API.new("WndProc.dll", "ReSetProc", "l", "l")
        # 设置RGSSEval的库
        SetDLL = Win32API.new("WndProc.dll", "SetDLL", "p", "v")
        # 在某些特殊情况下可能会用上,
        # RM的过程,基本上这个不调用,
        # 只需调用UseRMWndProc即可,链接库会自动调用。
        OldProc = Win32API.new("WndProc.dll", "OldProc", "llll", "l")
        # 使用RM的Proc
        UseRMWndProc = Win32API.new("WndProc.dll", "UseRMWndProc", "", "v")
        # 读取INI
        GetPrivateProfileString = Win32API.new("kernel32", "GetPrivateProfileString", "pppplp", "l")
        # 获取某个键是否按下
        GetAsyncKeyState = Win32API.new("user32","GetAsyncKeyState","l","l")
        # 设置鼠标显示
        # ShowCursor = Win32API.new("user32", "ShowCursor", "l", "l")
        # 发送消息
        SendMessage = Win32API.new("user32", "SendMessage", "llll", "l")
      end
      # 参数表
      module WM_MSG
        # 一些必须使用的消息
        WM_PAINT                      = 0x000f
        WM_HELP                       = 0x0053
        WM_CLOSE                      = 0x0010
        WM_CHAR                       = 0x0102
        WM_ACTIVATEAPP                = 0x001C
        WM_WINDOWPOSCHANGED           = 0x0047
        WM_SETCURSOR                  = 0x0020
        WM_COMMAND                    = 0x0111
        WM_SYSCOMMAND                 = 0x0112

        
        # 鼠标相关
        WM_MOUSEMOVE                  = 0x0200
        WM_LBUTTONDOWN                = 0x0201
        WM_LBUTTONUP                  = 0x0202
        WM_LBUTTONDBLCLK              = 0x0203
        WM_RBUTTONDOWN                = 0x0204
        WM_RBUTTONUP                  = 0x0205
        WM_RBUTTONDBLCLK              = 0x0206
        WM_MBUTTONDOWN                = 0x0207
        WM_MBUTTONUP                  = 0x0208
        WM_MBUTTONDBLCLK              = 0x0209
        WM_MOUSEWHEEL                 = 0x020a

      end
    end
  end
end
#===============================================================================
# ■  FSL 重载窗口过程
#    FSL WndProc
#===============================================================================
module WndProc
  # 包含API声明
  include FSL::Conf::WndProc::Win_API
  # 包含消息常数
  include FSL::Conf::WndProc::WM_MSG
  # 是否初始化过
  @@inid ||= false
  # 函数
  module_function
  #--------------------------------------------------------------------------
  # ● 初始化
  #--------------------------------------------------------------------------
  def init
    # 防止重复
    return if @@inid
    @@inid = true
    # 重置窗口过程
    self.re_set_proc
    # 隐藏鼠标
    # ShowCursor.call(0)
    # 注册的消息响应
    @@reg_back_proc = {}
    # Mouse.restart
  end
  #-------------------------------------------------------------------------
  # ● 注册消息响应
  #--------------------------------------------------------------------------
  def reg_back_msg(message, proc)
    @@reg_back_proc[message] ||= []
    @@reg_back_proc[message] << proc
  end
  #--------------------------------------------------------------------------
  # ● 注销消息响应
  #--------------------------------------------------------------------------
  def unreg_back_msg(message, proc)
    @@reg_back_proc[message] ||= []
    @@reg_back_proc[message].delete(proc)
  end
  #--------------------------------------------------------------------------
  # ● 窗口句柄
  #--------------------------------------------------------------------------
  def hWnd
    buffer = "\000"*256
    GetPrivateProfileString.call("Game", "Title", "", buffer, 256, "./Game.ini")
    buffer.delete!("\000")
    hWnd = FindWindow.call("RGSS Player", buffer)
    return hWnd
  end
  #--------------------------------------------------------------------------
  # ● 设置连接库
  #--------------------------------------------------------------------------
  def set_dll()
    libname = "\000"*256
    GetPrivateProfileString.call("Game", "Library", "", buffer, 256, "./Game.ini")
    libname.delete!("\000")
    SetDLL.call(libname)
  end
  #--------------------------------------------------------------------------
  # ● 重置
  #--------------------------------------------------------------------------
  def re_set_proc
    ReSetProc.call(self.hWnd)
  end
  #--------------------------------------------------------------------------
  # ● 新的回调函数
  #--------------------------------------------------------------------------
  def proc(hWnd, message, wParam, lParam)
    # 处理消息
    case message
    when WM_CLOSE           
      use_rm_proc();
    when WM_CHAR
      use_rm_proc();
    when WM_ACTIVATEAPP     
      use_rm_proc();
    when WM_WINDOWPOSCHANGED
      use_rm_proc();
    when WM_MOUSEMOVE
      use_rm_proc();
    when WM_COMMAND         
      use_rm_proc();
    when WM_SYSCOMMAND      
      use_rm_proc();
     when WM_PAINT
      #ShowCursor.call(0)
    when WM_HELP
      #ShowCursor.call(1)
    end
    unless @@reg_back_proc[message].nil?
      @@reg_back_proc[message].each do |back_proc|
        back_proc.call(hWnd, message, wParam, lParam)
      end
    end
  end
  #--------------------------------------------------------------------------
  # ● 本消息调用RM的过程
  #--------------------------------------------------------------------------
  def use_rm_proc
    UseRMWndProc.call()
  end
end