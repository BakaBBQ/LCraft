Kernel.require 'c:/rmsfx/rmsfx'
require 'inline'
class WorldGen_Table < Table
  inline do |builder|
    builder.c_raw <<-C
    #define W = 200
    #define H = 200
    static unsigned short* my_adr;
    static int table[200][200]  = {{0}}; 
    static int xSize;
    static int ySize;
    
      int init(int argc, int *argv, int **self){
        my_adr = (unsigned short *)self[4][7];
      }
      
      int rand_land(){
      }
      
      
      
      
    C
    
  end
  
  def c_prepare
    
  end
end

x = WorldGen_Table.new(3,3)
#x[0] = 1
x.init


#~ x.each_coord do |a,b|
#~   puts "#{a},#{b} => #{x[a,b]}"
#~ end
