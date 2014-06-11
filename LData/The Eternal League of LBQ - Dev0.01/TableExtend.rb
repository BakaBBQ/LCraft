module TableExtend
  def dimensions
    n = 0
    [xsize, ysize, zsize].each do |s|
      n += 1 if s != 0
    end
  end
  
  def each_coord(&block)
    xsize.times do |x|
      ysize.times do |y|
        yield x,y
      end
    end
    
  end
  
  def enlarge(size = 2)
    result = Table.new(xsize*size,ysize*size)
    
  end
  
  def flatten_xy(num)
    new_table = Table.new(self.xsize, self.ysize)
    self.xsize.times do |x|
      self.ysize.times do |y|
        #self.zsize.times do |z|
          new_table[x,y] = self[x,y,num]
        #end
      end
    end
    return new_table
  end
  
  
  
  
#~   def each(&block)
#~     case dimensions
#~     when 0
#~       yield "WTF"
#~     when 1
#~       xsize.times do |x|
#~         yield self[x]
#~       end
#~     when 2
#~       xsize.times do |x|
#~         ysize.times do |y|
#~           yield self[x,y]
#~         end
#~       end
#~     when 3
#~       xsize.times do |x|
#~         ysize.times do |y|
#~           zsize.times do |z|
#~             yield self[x,y,z]
#~           end
#~         end
#~       end
#~     end
#~     return self
#~   end
  
  
  
  
  def each_with_index(&block)
    case dimensions
    when 1
    when 2
      xsize.times do |x|
        ysize.times do |y|
          #zsize.times do |z|
            yield self[x,y], x, y
          #end
        end
      end
    when 3
      xsize.times do |x|
        ysize.times do |y|
          zsize.times do |z|
            yield self[x,y,z], x, y, z
          end
        end
      end
    end
    
  end
  
  def each_with_3index(&block)

      xsize.times do |x|
        ysize.times do |y|
          zsize.times do |z|
            yield self[x,y,z], x, y, z
          end
        end
      end

  end

  
  def to_map
    return MapData.new(self)
  end
  
  
  
  def each_xy(&block)
    xsize.times do |x|
        ysize.times do |y|
          yield [self[x,y,0], self[x,y,1], self[x,y,2]]
        end
    end
  end
  
  
  def inspect
    return
    xsize.times do |x|
        ysize.times do |y|
          zsize.times do |z|
#            puts "#{x}, #{y}, #{z}: #{self[x,y,z]}"
          end
        end
    end
  end
  
  
end



class Table
  include TableExtend
  [:x,:y,:z].each do |dimension|
    alias_method "#{dimension}_size".to_sym, "#{dimension}size"
  end
end
