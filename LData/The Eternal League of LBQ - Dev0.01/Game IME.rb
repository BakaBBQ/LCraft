#-------------------------------------------------------------------------------
# ▼ 通用配置模块
#-------------------------------------------------------------------------------
module FSL
  module Conf
    module WndProc
      module Win_API
        InitIME          = Win32API.new("WinIME.dll", "initIME", "l", "l")
        GetCandidataList = Win32API.new("WinIME.dll", "GetCandidataList", "pl", "l")
        GetCandidataCount= Win32API.new("WinIME.dll", "GetCandidataCount", "", "l")
        GetCandidataSize = Win32API.new("WinIME.dll", "GetCandidataSize", "v", "l")
        GetIndexChar     = Win32API.new("WinIME.dll", "GetIndexChar", "plp", "l")
        GetCharLen       = Win32API.new("WinIME.dll", "GetCharLen", "pi", "l")
        GetCount         = Win32API.new("WinIME.dll", "GetCount", "p", "l")
        GetPageSize      = Win32API.new("WinIME.dll", "GetPageSize", "p", "l")
        GetNowChar       = Win32API.new("WinIME.dll", "GetNowChar", "pl", "l")
        GetNowCharLen    = Win32API.new("WinIME.dll", "GetNowCharLen", "", "l")
        GetStyle         = Win32API.new("WinIME.dll", "GetStyle", "p", "l")
        GetDescription   = Win32API.new("WinIME.dll", "GetDescription", "p", "l")
        ChangeChar       = Win32API.new("WinIME.dll", "ChangeChar", "lp", "l")
        SetFocus         = Win32API.new("user32", "SetFocus", "l", "l")
        GetModuleHandle  = Win32API.new("kernel32", "GetModuleHandle", "p", "l")
        CreateWindow     = Win32API.new("user32", "CreateWindowEx", "lpplllllllll", "l")
      end
      module WM_MSG
        WM_KEYDOWN                    = 0x0100
        WM_IME_CHAR                   = 0x0286
        WM_IME_STARTCOMPOSITION       = 0x010d
        WM_IME_ENDCOMPOSITION         = 0x010e
        WM_IME_COMPOSITION            = 0x010f
        WM_IME_SELECT                 = 0x0285
        GWL_STYLE                     = -16
      end
    end
  end
end


# 处理游戏中输入的类
class GameIME
  # 包含API声明
  include FSL::Conf::WndProc::Win_API
  # 包含消息常数
  include FSL::Conf::WndProc::WM_MSG
  # 对外
  attr_reader   :now_str, :can_list
  # 初始化
  def initialize
    # 窗口
    @hWnd = CreateWindow.call(1,"Edit", "", 0x40000000,0,0,640,480,WndProc.hWnd,0,GetModuleHandle.call(nil),0)
    # 初始化
    InitIME.call(@hWnd)
    # 申请响应
    reg_message
    # 组合中的字符
    @now_str = ""
    # 待选列表
    @can_list = []
    # CHAR 已经输入的字符
    @char = []
    # 组合中.?
    @composinion = false
    # 一页可选择的项目数
    @page_item_size = 0
    # 当前页拥有的项目数
    @page_now_size = 0
  end
  def description
    name = self.get_money(255)
    GetDescription.call(name)
    name.delete!("\000")
    return EasyConv::s2u(name)
  end
  # 已经输入的字符
  def char
    return @char.shift.to_s
  end
  # 申请响应
  def reg_message
    # 设置Proc
    message_proc = Proc.new do |hWnd, message, wParam, lParam| 
      self.pop_message(hWnd, message, wParam, lParam) 
    end
    # 申请响应
    WndProc.reg_back_msg(WM_CHAR, message_proc)
    WndProc.reg_back_msg(WM_IME_CHAR, message_proc)
    WndProc.reg_back_msg(WM_IME_COMPOSITION, message_proc)
    WndProc.reg_back_msg(WM_IME_STARTCOMPOSITION, message_proc)
    WndProc.reg_back_msg(WM_KEYDOWN, message_proc)
  end
  # 申请空间
  def get_money(size)
    return "\000" * size
  end
  # 清楚
  def clear
    @can_list.clear
    @now_str = ""
  end
  # 一页可选择的项目数
  def page_item_size
    return @page_item_size
  end
  def page_now_size
    return @page_now_size
  end
  # 消息处理
  def pop_message(hWnd, message, wParam, lParam)
    
    case message
    when WM_CHAR
      
      case  wParam
      when 13,32..126
        @char << wParam.chr if wParam
      end
    when WM_IME_CHAR
      chinastr = self.get_money(2)
      ChangeChar.call(wParam, chinastr)
      @char << EasyConv::s2u(chinastr).delete("\000")
    when WM_IME_STARTCOMPOSITION # 开始组合
      @composinion = true
    when WM_IME_ENDCOMPOSITION   # 组合结束
      @composinion = false
      self.clear
    when WM_KEYDOWN              # KEY DOWN
      # 申请LPCANDIDATELIST
      candidatelist = self.get_money( GetCandidataSize.call() )
      # 设置LPCANDIDATELIST
      GetCandidataList.call( candidatelist, GetCandidataSize.call() )
      # 申请当前组合文字需要的空间
      @now_str = self.get_money( GetNowCharLen.call() )
      # 设置当前组合的文字
      GetNowChar.call( @now_str, GetNowCharLen.call() )
      # 转码
      @now_str = EasyConv::s2u(@now_str)
      # 清空列表
      @can_list.clear
      # GetCandidataCount.call
      @page_now_size = GetCount.call( candidatelist )
      @page_item_size = GetPageSize.call( candidatelist )
      # 无组合字时
      return if @now_str == "\000"
      # 异型。。
      return if GetStyle.call(candidatelist) > 5
      # 设置待选列表
      for i in 0...GetPageSize.call( candidatelist )##GetCount.call( candidatelist )
        str = get_money( GetCharLen.call(candidatelist, i) )
        if GetIndexChar.call( candidatelist, i, str ) != 0
          break;
        end
        @can_list << EasyConv::s2u(str)
      end
    when WM_IME_COMPOSITION      # 组合过程 (-.-翻页时居然没这消息..
      
    end
    
  end
  def release
  end
end
