module RMark::Window
  def load_file(filename)
    f = File.open filename 
    puts contents.height
    template = ERB.new f.read
#~     @test = 'This is the test'
    contents = f.read
    contents = template.result(binding)
    
    contents.each_line do |l|
      r = /^\#{1,}/
      r = r.match l
      if r
        hash_count = r[0].length
        l.slice!(0,hash_count)
        
      else
        hash_count = 0
      end
      l = l.chomp
      write(l,hash_count)
    end
  end
  
  def dynamic(*args)
    puts "dynamic" + args.to_s
    @uc = RMark::UpdateChannel.new(*args,self)
  end
  
end