FileUtils.mkdir_p "Data_BK"
FileUtils.cp_r(Dir['Data/*'] - Dir['Data/Map*'],'Data_BK')