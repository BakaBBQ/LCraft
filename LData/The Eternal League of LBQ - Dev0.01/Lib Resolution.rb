#encoding:utf-8
#==============================================================================
# ■ String
#------------------------------------------------------------------------------
# 　String 类追加定义。
#==============================================================================
 
class String
  #----------------------------------------------------------------------------
  # ● API
  #----------------------------------------------------------------------------
  @@MultiByteToWideChar  = Win32API.new('kernel32', 'MultiByteToWideChar', 'ilpipi', 'i')
  @@WideCharToMultiByte  = Win32API.new('kernel32', 'WideCharToMultiByte', 'ilpipipp', 'i')
  #----------------------------------------------------------------------------
  # ● UTF-8 转 Unicode
  #----------------------------------------------------------------------------
  def u2w
    i = @@MultiByteToWideChar.call(65001, 0 , self, -1, nil,0)
    buffer = "\0" * (i*2)
    @@MultiByteToWideChar.call(65001, 0 , self, -1, buffer, i)
    buffer.chop!
    return buffer
  end  
  #----------------------------------------------------------------------------
  # ● Unicode 转 UTF-8
  #----------------------------------------------------------------------------
  def w2u
    i = @@WideCharToMultiByte.call(65001, 0 , self, -1, nil, 0, nil, nil)
    buffer = "\0" * (i)
    @@WideCharToMultiByte.call(65001, 0 , self, -1, buffer, i, nil, nil)
    buffer.chop!
    return buffer
  end  
  #----------------------------------------------------------------------------
  # ● UTF-8 转系统编码
  #----------------------------------------------------------------------------
  def u2s
    i = @@MultiByteToWideChar.call(65001, 0 , self, -1, nil,0)
    buffer = "\0" * (i*2)
    @@MultiByteToWideChar.call(65001, 0 , self, -1, buffer, i)
    i = @@WideCharToMultiByte.call(0, 0, buffer, -1, nil, 0, nil, nil)
    result = "\0" * i
    @@WideCharToMultiByte.call(0, 0, buffer, -1, result, i, nil, nil)
    result.chop!
    return result
  end
  #----------------------------------------------------------------------------
  # ● 系统编码转 UTF-8
  #----------------------------------------------------------------------------
  def s2u
    i = @@MultiByteToWideChar.call(0, 0, self, -1, nil, 0)
    buffer = "\0" * (i*2)
    @@MultiByteToWideChar.call(0, 0, self, -1, buffer, buffer.size / 2)
    i = @@WideCharToMultiByte.call(65001, 0, buffer, -1, nil, 0, nil, nil)
    result = "\0" * i
    @@WideCharToMultiByte.call(65001, 0, buffer, -1, result, result.size, nil, nil)
    result.chop!
    return result
  end
end
 
#==============================================================================
# ■ AceResolutionMemoryPatch
#------------------------------------------------------------------------------
#  用于调整RMACE分辨率的内存补丁脚本，免修改DLL。
#
#   by 灼眼的夏娜（感谢fux2君提供内存地址）
#==============================================================================
# 更多脚本请转到 [url]www.66rpg.com[/url]。
#==============================================================================
module AceResolutionMemoryPatch
 
  GetModuleFileName       = Win32API.new("kernel32", "GetModuleFileName", "lpl", "l")
  GetPrivateProfileString = Win32API.new("kernel32", "GetPrivateProfileString", "pppplp", "l")
  GetModuleHandle         = Win32API.new("kernel32", "GetModuleHandle", "p", "l")
  RtlMoveMemory           = Win32API.new("kernel32", "RtlMoveMemory", "pli", "v")
  RtlMoveMemoryLP         = Win32API.new("kernel32", "RtlMoveMemory", "lpi", "v")
  VirtualProtect          = Win32API.new("kernel32", "VirtualProtect", "lllp", "i")
  FindWindow              = Win32API.new("user32", "FindWindow", "pp", "l")
 
  module_function
 
  def patch(width = 800, height = 600)
    # 获取句柄
    path = 0.chr * 256
    return false if 0 == GetModuleFileName.call(0, path, path.size)
    path = path.s2u.gsub!(/.exe/ ,".ini").u2s
    buff = 0.chr * 256
    return false if 0 == GetPrivateProfileString.call("Game", "Library", nil, buff, buff.size, path)
    buff.delete!("\0")
    rgsshandle = GetModuleHandle.call(buff)
    # 获取标题名和脚本名字
    title = 0.chr * 256
    return false if 0 == GetPrivateProfileString.call("Game", "Title", nil, title, title.size, path)
    title = title.s2u.delete("\0").u2s
    scripts = 0.chr * 256
    return false if 0 == GetPrivateProfileString.call("Game", "Scripts", nil, scripts, scripts.size, path)
    scripts = scripts.s2u.delete("\0").u2w
    # 地址表
    addr = 
    {
      # 直接宽度替换
      :w0 => [0x000016EE, 0x000020F6, 0x000020FF, 0x0010DFED, 0x0010E025, 0x0010E059, 0x0010E08D, 0x000019AA, 0x00001A5B, 0x0001C528, 0x0001F49C, 0x0010E7E7, 0x0010EFE9],
      # 直接高度替换
      :h0 => [0x000016E9, 0x00002106, 0x0000210F, 0x0010DFE8, 0x0010E020, 0x0010E054, 0x0010E088, 0x000019A5, 0x00001A56, 0x0001C523, 0x0001F497, 0x0010E803, 0x0010EFF9],
 
      # 宽度+32
      :w1 => [0x000213E4],
      # 高度+32
      :h1 => [0x000213DF],
 
      # 最大宽度/32+1
      :w2 => [0x00021FE1],
      # 最大高度/32+1
      :h2 => [0x00021F5D]
    }
    # 更新
    w0 = [width].pack("L")
    addr[:w0].each{|ofs| return false if !write_memory(rgsshandle + ofs, w0)}
    h0 = [height].pack("L")
    addr[:h0].each{|ofs| return false if !write_memory(rgsshandle + ofs, h0)}
    w1 = [width + 32].pack("L")
    addr[:w1].each{|ofs| return false if !write_memory(rgsshandle + ofs, w1)}
    h1 = [height + 32].pack("L")
    addr[:h1].each{|ofs| return false if !write_memory(rgsshandle + ofs, h1)}
    w2 = [width / 32 + 1].pack("C")
    addr[:w2].each{|ofs| return false if !write_memory(rgsshandle + ofs, w2)}
    h2 = [height / 32 + 1].pack("C")
    addr[:h2].each{|ofs| return false if !write_memory(rgsshandle + ofs, h2)}
    # 重启
    # RGSSReset：发生syntax error时出错位置不正确
    #raise RGSSReset.new
    # rgssgamemain：会在module AceResolutionMemoryPatch下加载脚本
    # 修改过根scope下模块的定义的脚本会出错
    # 并且缺end的情况下出错位置不正确
    #rgssgamemain = Win32API.new(buff, "RGSSGameMain", "ipp", "v")
    #rgssgamemain.call(FindWindow.call("RGSS Player", title), scripts, "")
    # 目前是不重启，看会不会有问题
    # 补丁成功
    return true
  end
 
  def write_memory(addr, str)
    old = 0.chr * 4
    return false if 0 == VirtualProtect.call(addr, str.size, 0x40, old)
    RtlMoveMemoryLP.call(addr, str, str.size)
    return false if 0 == VirtualProtect.call(addr, str.size, old.unpack("L").first, old)
    return true
  end
  private_class_method :write_memory
 
  def read_byte(addr)
    dst = 0.chr * 1
    RtlMoveMemory.call(dst, addr, dst.size)
    return dst.unpack("C").first
  end
  private_class_method :read_byte
 
  def read_dword(addr)
    dst = 0.chr * 4
    RtlMoveMemory.call(dst, addr, dst.size)
    return dst.unpack("L").first
  end
  private_class_method :read_dword
 
end
 
unless $ace_patched
  $ace_patched = true
  raise "应用分辨率补丁失败！" unless AceResolutionMemoryPatch.patch(1024, 640)
end
 
Graphics.resize_screen(832, 480)