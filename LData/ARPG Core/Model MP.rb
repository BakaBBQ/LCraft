#~ class ManaPoint
#~   attr_accessor :point, :delay
#~   def initialize
#~     @point = 0
#~     @delay = 0
#~     @timer = 0
#~   end
#~   
#~   def update
#~     @timer += 1
#~     @delay -= 1 if @delay >= 0
#~     @point += 1 if @timer % 3 == 0 && @delay <= 0
#~     @timer = 0 if @timer == 600
#~   end
#~   
#~   def method_missing(a,*b,&c)
#~     @point.send a, *b, &c
#~   end
#~ end