#encoding:utf-8
#==============================================================================
# ■ Tile
#------------------------------------------------------------------------------
# 　代表地图元件
#==============================================================================

class Tile
  #--------------------------------------------------------------------------
  # ● 类方法：组、序号、形状=>ID
  #--------------------------------------------------------------------------
  def self.set_to_tile_id(set, index, shape = 0)
    case set
    when :A1
      return 2048 + index * 48 + shape
    when :A2
      return 2816 + index * 48 + shape
    when :A3
      return 4352 + index * 48 + shape
    when :A4
      return 5888 + index * 48 + shape
    when :A5
      return 1536 + index
    when :B
      return index
    when :C
      return 256 + index
    when :D
      return 512 + index
    when :E
      return 768 + index
    end
    return 0
  end
  #--------------------------------------------------------------------------
  # ● 类方法：ID=>组、序号、形状
  #--------------------------------------------------------------------------
  def self.tile_id_to_set(id)
    if id < 256
      return :B, id, 0
    elsif id < 512
      return :C, id - 256, 0
    elsif id < 768
      return :D, id - 512, 0
    elsif id < 1024
      return :E, id - 768, 0
    elsif id >= 1536 && id < 1664
      return :A5, id - 1536, 0
    elsif id >= 2048 && id < 2816
      return :A1, (id - 2048) / 48, (id - 2048) % 48
    elsif id >= 2816 && id < 4352
      return :A2, (id - 2816) / 48, (id - 2816) % 48
    elsif id >= 4352 && id < 5888
      return :A3, (id - 4352) / 48, (id - 4352) % 48
    elsif id >= 5888
      return :A4, (id - 5888) / 48, (id - 5888) % 48
    end
    p "WARNING: Invalid id: #{id}"
    return :B, 0, 0
  end
  #--------------------------------------------------------------------------
  # ● 类方法：转换成Tile对象
  #--------------------------------------------------------------------------
  def self.to_tile(t)
    if t.is_a?(Tile)
      return t
    else
      return Tile.new(t)
    end
  end
  #--------------------------------------------------------------------------
  # ● 类方法：转换成tile_id
  #--------------------------------------------------------------------------
  def self.to_tile_id(t)
    if t.is_a?(Tile)
      return t.tile_id
    else
      return t
    end
  end
  #--------------------------------------------------------------------------
  # ● 类方法：返回图块组中的图块数量
  #--------------------------------------------------------------------------
  def self.tile_count(set)
    case set
    when :A1
      return 16
    when :A2
      return 32
    when :A3
      return 32
    when :A4
      return 24
    when :A5
      return 128
    when :B, :C, :D, :E
      return 256
    end
    p "WARNING: cannot find tile number for #{set}"
    return 0
  end
  #--------------------------------------------------------------------------
  # ● 初始化
  #   参数为tile_id或set,index[,shape]
  #   参数为空的话tile_id为0
  #--------------------------------------------------------------------------
  def initialize(*args)
    if args.size == 0
      self.tile_id = 0
    elsif args.size == 1
      self.tile_id = args.first
    elsif args.size == 2
      @set, @index = *args
      @shape = 0
      @tile_id = Tile.set_to_tile_id(@set, @index, @shape)
    elsif args.size == 3
      @set, @index, @shape = *args
      @shape = sample_shape if @shape == :sample
      @tile_id = Tile.set_to_tile_id(@set, @index, @shape)
    else
      raise ArgumentError
    end
  end
  #--------------------------------------------------------------------------
  # ● 属性
  #--------------------------------------------------------------------------
  attr_reader :set, :index, :shape, :tile_id
  def set=(n)
    @set = n
    @tile_id = Tile.set_to_tile_id(@set, @index, @shape)
  end
  def index=(n)
    @index = n
    @tile_id = Tile.set_to_tile_id(@set, @index, @shape)
  end
  def shape=(n)
    @shape = n
    @tile_id = Tile.set_to_tile_id(@set, @index, @shape)
  end
  def tile_id=(n)
    @tile_id = n
    @set, @index, @shape = Tile.tile_id_to_set(@tile_id)
  end
  #--------------------------------------------------------------------------
  # ● 元件类型
  #   :type_2x3 :type_2x2 :type_2x1
  #--------------------------------------------------------------------------
  def type
    case @set
    when :A1
      if @index <= 3
        return :type_2x3
      else
        if @index % 2 == 0
          return :type_2x3
        else
          return :type_2x1
        end
      end
    when :A2
      return :type_2x3
    when :A3
      return :type_2x2
    when :A4
      if (@index / 8) % 2 == 0
        return :type_2x3
      else
        return :type_2x2
      end
    end
    return :type_1x1
  end
  #--------------------------------------------------------------------------
  # ● 是否属于同一个元件
  #-------------------------------------------------------------------------
  def same_tile?(other)
    return @set == other.set && @index == other.index
  end
  #--------------------------------------------------------------------------
  # ● 计算形状
  #-------------------------------------------------------------------------
  def calculate_shape(surround)
    case type
    when :type_2x3
      return autotile_2x3_shape(surround)
    when :type_2x2
      return autotile_2x2_shape(surround)
    when :type_2x1
      return autotile_2x1_shape(surround)
    when :type_1x1
      return 0
    end
    p "WARNING: cannot find shape for set #{@set} index #{@index} surround 0b#{surround.to_s(2)}"
    return 0
  end
  #--------------------------------------------------------------------------
  # ● 返回图块缩略图形状
  #--------------------------------------------------------------------------
  def sample_shape
    case type
    when :type_2x3
      return 46
    when :type_2x2
      return 15
    when :type_2x1
      return 3
    end
    return 0
  end
  #--------------------------------------------------------------------------
  # ● 辅佐方法
  #--------------------------------------------------------------------------
  protected
  #--------------------------------------------------------------------------
  # ● 2x3自动元件形状
  #--------------------------------------------------------------------------
  def autotile_2x3_shape(surround)
    # 如果上、下、左或右方向没有相邻同样图块的话，无视对应方向的两个角
    surround &= 0b01011111 if surround | 0b10111111 == 0b10111111
    surround &= 0b01111011 if surround | 0b11101111 == 0b11101111
    surround &= 0b11011110 if surround | 0b11110111 == 0b11110111
    surround &= 0b11111010 if surround | 0b11111101 == 0b11111101
    return AUTOTILE_2X3_SHAPES[surround]
  end
  #--------------------------------------------------------------------------
  # ● 2x2自动元件形状
  #--------------------------------------------------------------------------
  def autotile_2x2_shape(surround)
    # 削去四个角
    surround &= 0b01011010
    return AUTOTILE_2X2_SHAPES[surround]
  end
  #--------------------------------------------------------------------------
  # ● 2x1自动元件形状
  #--------------------------------------------------------------------------
  def autotile_2x1_shape(surround)
    # 削去上下两条边
    surround &= 0b00011000
    return AUTOTILE_2X1_SHAPES[surround]
  end
  #--------------------------------------------------------------------------
  # ● 辅佐常量
  #--------------------------------------------------------------------------
  #--------------------------------------------------------------------------
  # ● 2x3自动元件形状
  #--------------------------------------------------------------------------
  AUTOTILE_2X3_SHAPES = {
    0b11111111 => 0,
    0b01111111 => 1,
    0b11011111 => 2,
    0b01011111 => 3,
    0b11111110 => 4,
    0b01111110 => 5,
    0b11011110 => 6,
    0b01011110 => 7,
    0b11111011 => 8,
    0b01111011 => 9,
    0b11011011 => 10,
    0b01011011 => 11,
    0b11111010 => 12,
    0b01111010 => 13,
    0b11011010 => 14,
    0b01011010 => 15,
    0b01101011 => 16, #16 左 8, 9, 4, 5
    0b01001011 => 17, #17 右上+左 8, 17, 4, 5
    0b01101010 => 18, #18 右下+左 8, 9, 4, 19
    0b01001010 => 19, #19 左+右上+右下 8, 17, 4, 19
    0b00011111 => 20, #20 上 2, 1, 6, 5
    0b00011110 => 21, #21 右下+上 2, 1, 6, 19
    0b00011011 => 22, #22 左下+上 2, 1, 18, 5
    0b00011010 => 23, #23 上+左下+右下 2, 1, 18, 19
    0b11010110 => 24, #24 右 10, 11, 6, 7
    0b11010010 => 25, #25 左下+右 10, 11, 18, 7
    0b01010110 => 26, #26 左上+右 16, 11, 6, 7
    0b01010010 => 27, #27 右+左上+左下 16, 11, 18, 7
    0b11111000 => 28, #28 下 10, 9, 14, 13
    0b01111000 => 29, #29 左上+下 16, 9, 14, 13
    0b11011000 => 30, #30 右上+下 10, 17, 14, 13
    0b01011000 => 31, #31 下+左上+右上 16, 17, 14, 13
    0b01000010 => 32, #32 右+左 8, 11, 4, 7 
    0b00011000 => 33, #33 上+下 2, 1, 14, 13
    0b00001011 => 34, #34 上+左 0, 1, 4, 5
    0b00001010 => 35, #35 右下+上+左 0, 1, 4, 19
    0b00010110 => 36, #36 上+右 2, 3, 6, 7
    0b00010010 => 37, #37 左下+上+右 2, 3, 18, 7
    0b11010000 => 38, #38 右+下 10, 11, 14, 15
    0b01010000 => 39, #39 左上+右+下 16, 11, 14, 15
    0b01101000 => 40, #40 下+左 8, 9, 12, 13
    0b01001000 => 41, #41 右上+左+下 8, 17, 12, 13
    0b00000010 => 42, #42 -下 0, 3, 8, 11
    0b00001000 => 43, #43 -右 0, 1, 12, 13
    0b01000000 => 44, #44 -上 4, 7, 12, 15
    0b00010000 => 45, #45 -左 2, 3, 14, 15
    0b00000000 => 46, #46 all 0, 3, 12, 15
  }
  AUTOTILE_2X3_SHAPES.default = 0
  #--------------------------------------------------------------------------
  # ● 2x1自动元件形状
  #--------------------------------------------------------------------------
  AUTOTILE_2X1_SHAPES = {
    0b00011000 => 0, #0 -all 2, 1, 6, 5
    0b00001000 => 1, #1 左 0, 1, 4, 5
    0b00010000 => 2, #2 右 2, 3, 6, 7
    0b00000000 => 3, #3 all 0, 3, 4, 7
  }
  AUTOTILE_2X1_SHAPES.default = 0
  #--------------------------------------------------------------------------
  # ● 2x2自动元件形状
  #--------------------------------------------------------------------------
  AUTOTILE_2X2_SHAPES = {
    0b01011010 => 0, #0 -all 10, 9, 6, 5
    0b01001010 => 1, #1 左 8, 9, 4, 5
    0b00011010 => 2, #2 上 2, 1, 6, 5
    0b00001010 => 3, #3 左+上 0, 1, 4, 5
    0b01010010 => 4, #4 右 10, 11, 6, 7
    0b01000010 => 5, #5 左+右 8, 11, 4, 7
    0b00010010 => 6, #6 上+右 2, 3, 6, 7
    0b00000010 => 7, #7 左+上+右 0, 3, 8, 11
    0b01011000 => 8, #8 下 10, 9, 14, 13
    0b01001000 => 9, #9 左+下 8, 9, 12, 13
    0b00011000 => 10, #10 上+下 2, 1, 14, 13
    0b00001000 => 11, #11 上+左+下 0, 1, 12, 13
    0b01010000 => 12, #12 右+下 10, 11, 14, 15
    0b01000000 => 13, #13 左+右+下 4, 7, 12, 15
    0b00010000 => 14, #14 上+右+下 2, 3, 14, 15
    0b00000000 => 15, #15 all 0, 3, 12, 15
  }
  AUTOTILE_2X2_SHAPES.default = 0
end


#==============================================================================
# ■ TileTable
#------------------------------------------------------------------------------
# 　地图操作模块，include到Table
#==============================================================================

module TileTable
  #--------------------------------------------------------------------------
  # ● 写入自动元件
  #   tile可以是Tile实例或整数ID
  #   z 0~2为层1～3，3为阴影层和区域，见def region_id
  #   阴影ID：0b(右下)(左下)(右上)(左上)
  #   region_id：id << 8
  #   :out_of_map_as_neighbor 超出地图范围视为同类自动元件，默认true
  #   :update_surround 是否更新周围自动元件的形状，默认true
  #--------------------------------------------------------------------------
  def set_autotile(x, y, z, tile, options={})
    return if !in_map?(x, y)
    set_default_options(options)
    # 转换
    tile = Tile.to_tile(tile)
    # 获取第一部分需要更新的元件
    if options[:update_surround]
      coords_to_update = get_related_coords(x, y, z, get_tile(x, y, z))
    else
      coords_to_update = [[x, y]]
    end
    # 写入元件（形状未调整）
    set_tile(x, y, z, tile)
    # 获取第二部分需要更新的元件
    if options[:update_surround]
      coords_to_update |= get_related_coords(x, y, z, tile)
    end
    # 更新列表中的所有元件
    coords_to_update.each do |xy|
      update_autotile_shape(*xy, z, options)
    end
  end
  
  
  def normalize_all
    puts "profiler running"
    #Profiler__.start_profile
    xsize.times do |x|
      ysize.times do |y|
        zsize.times do |z|
          update_autotile_shape(x,y,z,{:out_of_map_as_neighbor => true})
        end
      end
    end
    #Profiler__.print_profile($stdout)
  end
  
  #--------------------------------------------------------------------------
  # ● 批量写入自动元件
  #   hash: [x, y] => Tile
  #--------------------------------------------------------------------------
  def set_autotiles(hash, z, options=Hash.new(true))
    set_default_options(options)
    # 获取第一部分需要更新的元件
    coords_to_update = []
    hash.each do |xy, tile|
      next if !in_map?(*xy)
      coords_to_update |= get_related_coords(*xy, z, get_tile(*xy, z))
    end
    # 写入元件（形状未调整）
    set_tiles(hash, z)
    # 获取第二部分需要更新的元件
    hash.each do |xy, tile|
      next if !in_map?(*xy)
      coords_to_update |= get_related_coords(*xy, z, Tile.to_tile(tile))
    end
    # 更新列表中的所有元件
    coords_to_update.each do |xy|
      update_autotile_shape(*xy, z, options)
    end
  end
  #--------------------------------------------------------------------------
  # ● 写入元件
  #--------------------------------------------------------------------------
  def set_tile(x, y, z, tile)
    return if !in_map?(x, y)
    if zsize == 1
      self[x, y] = Tile.to_tile_id(tile)
    else
      self[x, y, z] = Tile.to_tile_id(tile)
    end
    
    
  end
  #--------------------------------------------------------------------------
  # ● 批量写入元件
  #   hash: [x, y] => Tile
  #--------------------------------------------------------------------------
  def set_tiles(hash, z)
    hash.each {|xy, tile| set_tile(*xy, z, tile)}
  end
  #--------------------------------------------------------------------------
  # ● 取得元件
  #--------------------------------------------------------------------------
  def get_tile(x, y, z)
    return if !in_map?(x, y)
    #puts x,y,z
    #puts xsize, ysize, zsize
    z = 0 if z.nil?
    return if !(x >= 0 && x < xsize && y >= 0 && y < ysize)
    if self.zsize == 1
      return Tile.new(self[x,y])
    end
#~     puts x,y,z
#~     self[x,y,z]
    return Tile.new(self[x, y, z])
  end
  #--------------------------------------------------------------------------
  # ● 坐标是否在地图范围内
  #--------------------------------------------------------------------------
  def in_map?(x, y)
    return x >= 0 && x < xsize && y >= 0 && y < ysize
  end
  #--------------------------------------------------------------------------
  # ● 辅佐方法
  #--------------------------------------------------------------------------
  protected
  #--------------------------------------------------------------------------
  # ● 设置默认选项
  #--------------------------------------------------------------------------
  def set_default_options(options)
    if options[:out_of_map_as_neighbor] == nil
      options[:out_of_map_as_neighbor] = true
    end
    if options[:update_surround] == nil
      options[:update_surround] = true
    end
  end
  #--------------------------------------------------------------------------
  # ● 返回相关坐标
  #--------------------------------------------------------------------------
  def get_related_coords(x, y, z, tile)
    coords = []
    case tile.type
    when :type_2x3 # 正方形
      for _x in x - 1..x + 1
        for _y in y - 1..y + 1
          coords.push([_x, _y]) if same_tile?(_x, _y, z, tile)
        end
      end
    when :type_2x2 # 需要扩展整片墙壁
      expand_coords(x, y, z, tile, coords)
    when :type_2x1 # 十字形
      [[x, y], [x-1, y], [x+1, y], [x, y-1], [x, y+1]].each do |xy|
        coords.push(xy) if same_tile?(*xy, z, tile)
      end
    end
    return coords
  end
  #--------------------------------------------------------------------------
  # ● 是否同一个元件
  #--------------------------------------------------------------------------
  def same_tile?(x, y, z, tile)
    if (target = get_tile(x, y, z)) == nil
      return false
    end
    return target.same_tile?(tile)
  end
  #--------------------------------------------------------------------------
  # ● 是否相邻
  #   超出地图范围也视为相邻
  #--------------------------------------------------------------------------
  def neighbor?(x, y, z, tile)
    if (target = get_tile(x, y, z)) == nil
      return true
    end
    return target.same_tile?(tile)
  end
  #--------------------------------------------------------------------------
  # ● 递归扩展坐标
  #--------------------------------------------------------------------------
  def expand_coords(x, y, z, tile, coords)
    return if !same_tile?(x, y, z, tile)
    return if coords.include?([x, y])
    coords.push([x, y])
    [[x-1, y], [x+1, y], [x, y-1], [x, y+1]].each do |xy|
      expand_coords(*xy, z, tile, coords)
    end
  end
  #--------------------------------------------------------------------------
  # ● 更新自动元件形状
  #--------------------------------------------------------------------------
  def update_autotile_shape(x, y, z, options = {})
    return if !in_map?(x, y)
    tile = get_tile(x, y, z)
    surround = get_surround(tile, x, y, z, options)
    tile.shape = tile.calculate_shape(surround)
    set_tile(x, y, z, tile)
  end
  #--------------------------------------------------------------------------
  # ● 返回周边情况
  #-------------------------------------------------------------------------
  def get_surround(tile, x, y, z, options = {})
    result = 0
    if tile.type == :type_2x1 || tile.type == :type_2x3
      if options[:out_of_map_as_neighbor]
        m = method(:neighbor?)
      else
        m = method(:same_tile?)
      end
      # ⑧方向
      result |= 0b10000000 if m.call(x - 1, y - 1, z, tile)
      result |= 0b01000000 if m.call(x, y - 1, z, tile)
      result |= 0b00100000 if m.call(x + 1, y - 1, z, tile)
      result |= 0b00010000 if m.call(x - 1, y, z, tile)
      result |= 0b00001000 if m.call(x + 1, y, z, tile)
      result |= 0b00000100 if m.call(x - 1, y + 1, z, tile)
      result |= 0b00000010 if m.call(x, y + 1, z, tile)
      result |= 0b00000001 if m.call(x + 1, y + 1, z, tile)
    elsif tile.type == :type_2x2
      # 上
      # 超出地图范围的话视为没有邻接
      result |= 0b01000000 if same_tile?(x, y - 1, z, tile)
      # 左和右
      # 本列最上面的元件决定邻接情况
      top_y = get_top_y(x, y, z)
      result |= 0b00010000 if neighbor?(x - 1, top_y, z, tile)
      result |= 0b00001000 if neighbor?(x + 1, top_y, z, tile)
      # 下
      # 不位于这面墙最下面的话视为有邻接
      # 超出地图范围的话视为没有邻接
      if in_map?(x, y + 1)
        if same_tile?(x, y + 1, z, tile)
          result |= 0b00000010
        else
          bottom_y = y
          _x = x - 1 # 检查左边
          while same_tile?(_x, y, z, tile) &&
              get_top_y(_x, y, z) == top_y
            _bottom_y = get_bottom_y(_x, y, z)
            bottom_y = _bottom_y if _bottom_y > bottom_y
            _x -= 1
          end
          _x = x + 1 # 检查右边
          while same_tile?(_x, y, z, tile) &&
              get_top_y(_x, y, z) == top_y
            _bottom_y = get_bottom_y(_x, y, z)
            bottom_y = _bottom_y if _bottom_y > bottom_y
            _x += 1
          end
          result |= 0b00000010 if bottom_y > y
        end
      end
    end
    return result
  end
  #--------------------------------------------------------------------------
  # ● 返回2x2元件列最上面的元件的y坐标
  #-------------------------------------------------------------------------
  def get_top_y(x, y, z)
    tile = get_tile(x, y, z)
    top_y = y
    top_y -= 1 while same_tile?(x, top_y - 1, z, tile)
    return top_y
  end
  #--------------------------------------------------------------------------
  # ● 返回2x2元件列最下面的元件的y坐标
  #-------------------------------------------------------------------------
  def get_bottom_y(x, y, z)
    tile = get_tile(x, y, z)
    bottom_y = y
    bottom_y += 1 while same_tile?(x, bottom_y + 1, z, tile)
    return bottom_y
  end
end

class Table
  include TileTable
end

