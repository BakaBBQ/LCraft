#------------------------------------------------------------------------------
# Moonlight INN
# http://cgi.members.interq.or.jp/aquarius/rasetsu/
# RaTTiE
# rasetsu@aquarius.interq.or.jp
#------------------------------------------------------------
# EasyConv::s2u(text) : S-JIS -> UTF-8
# EasyConv::u2s(text) : UTF-8 -> S-JIS
#==============================================
module EasyConv
 # API梡掕悢掕媊
   CP_ACP = 0
   CP_UTF8 = 65001

 #--------------------------------------------------------------------------
 # 仠 S-JIS -> UTF-8
 #--------------------------------------------------------------------------
 def s2u(text)
 # API掕媊
   m2w = Win32API.new('kernel32', 'MultiByteToWideChar', 'ilpipi', 'i')
   w2m = Win32API.new('kernel32', 'WideCharToMultiByte', 'ilpipipp', 'i')

 # S-JIS -> Unicode
   len = m2w.call(CP_ACP, 0, text, -1, nil, 0);
   buf = "\0" * (len*2)
   m2w.call(CP_ACP, 0, text, -1, buf, buf.size/2);

 # Unicode -> UTF-8
   len = w2m.call(CP_UTF8, 0, buf, -1, nil, 0, nil, nil);
   ret = "\0" * len
   w2m.call(CP_UTF8, 0, buf, -1, ret, ret.size, nil, nil);
   
   return ret
 end
 # module_function偲偟偰岞奐
 module_function :s2u
 #--------------------------------------------------------------------------
 # 仠 UTF-8 -> S-JIS
 #--------------------------------------------------------------------------
 def u2s(text)
 # API掕媊
   m2w = Win32API.new('kernel32', 'MultiByteToWideChar', 'ilpipi', 'i')
   w2m = Win32API.new('kernel32', 'WideCharToMultiByte', 'ilpipipp', 'i')

 # UTF-8 -> Unicode
   len = m2w.call(CP_UTF8, 0, text, -1, nil, 0);
   buf = "\0" * (len*2)
   m2w.call(CP_UTF8, 0, text, -1, buf, buf.size/2);

 # Unicode -> S-JIS
   len = w2m.call(CP_ACP, 0, buf, -1, nil, 0, nil, nil);
   ret = "\0" * len
   w2m.call(CP_ACP, 0, buf, -1, ret, ret.size, nil, nil);
   
   return ret
 end
 # module_function偲偟偰岞奐
 module_function :u2s
end

#========================================
# 本脚本来自www.66rpg.com
#========================================
