module Perlin
  VERSION = "0.1.2"
end

module Perlin
  module Curve
    LINEAR  = proc { |t| t }
    CUBIC   = proc { |t| 3 * (t ** 2) - 2 * (t ** 3) }
    QUINTIC = proc { |t| 6 * (t ** 5) - 15 * (t ** 4) + 10 * (t ** 3) }

    # Returns a Proc object which applies S-curve function to
    # a given number between 0 and 1.
    # @param[Proc] curve
    # @param[Fixnum] times
    # @return[Proc]
    def self.contrast curve, times
      lambda { |n|
        times.times do
          n = curve.call n
        end
        n
      }
    end
  end
end

module Perlin
  if RUBY_VERSION =~ /^1\.8\./
    class Random
      def initialize *seed
        # FIXME: Sets the global seed value; this is misleading
        srand *seed
      end

      def rand *interval
        Kernel.rand *interval
      end
    end
  else
    Random = ::Random
  end

  class GradientTable
    # Bit-wise AND operation is not any faster than MOD in Ruby
    # MOD operation returns positive number for negative input
    def initialize dim, interval = 256, seed = nil
      @dim = dim
      @interval = interval
      @random = Random.new(*[seed].compact)

      @table   = Array.new(interval) { @random.rand @interval }
      @vectors = Array.new(interval) { random_unit_vector }
    end

    def [] *coords
      @vectors[index *coords]
    end

  private
    # A simple hashing
    def index *coords
      s = coords.last
      coords.reverse[1..-1].each do |c|
        s = perm(s) + c
      end
      perm(s)
    end

    def perm s
      @table[s % @interval]
    end

    def random_unit_vector
      while true
        v = Vector[*Array.new(@dim) { @random.rand * 2 - 1 }]
        # Discards vectors whose length greater than 1 to avoid bias in distribution
        break if v.r > 0 && v.r <= 1
      end
      r = v.r
      v.map { |e| e / v.r }
    end
  end
end

module Perlin
  class Noise
    DEFAULT_OPTIONS = {
      :interval => 256,
      :curve => Perlin::Curve::QUINTIC,
      :seed => nil
    }

    def initialize dim, options = {}
      options = DEFAULT_OPTIONS.merge options

      @dim = dim
      @interval = options.fetch(:interval)
      @curve = options.fetch(:curve)
      @seed = options.fetch(:seed)

      raise ArgumentError.new("Invalid dimension: must be a positive integer")  unless @dim.is_a?(Fixnum) && @dim > 0
      raise ArgumentError.new("Invalid interval: must be a positive integer")   unless @interval.is_a?(Fixnum) && @interval > 0
      raise ArgumentError.new("Invalid curve specified: must be a Proc object") unless @curve.is_a?(Proc)
      raise ArgumentError.new("Invalid seed: must be a number")                 unless @seed.nil? || @seed.is_a?(Numeric)

      # Generate pseudo-random gradient vector for each grid point
      @gradient_table = Perlin::GradientTable.new @dim, @interval, @seed
    end

    # @param [*coords] Coordinates
    # @return [Float] Noise value between (-1..1)
    def [] *coords
      raise ArgumentError.new("Invalid coordinates") unless coords.length == @dim

      coords = Vector[*coords]
      cell = Vector[*coords.map(&:to_i)]
      diff = coords - cell

      # Calculate noise factor at each surrouning vertex
      nf = {}
      iterate @dim, 2 do |idx|
        idx = Vector[*idx]

        # "The value of each gradient ramp is computed by means of a scalar
        # product (dot product) between the gradient vectors of each grid point
        # and the vectors from the grid points."
        gv = @gradient_table[ * (cell + idx).to_a ]
        nf[idx.to_a] = gv.inner_product(diff - idx)
      end

      dim = @dim
      diff.to_a.each do |u|
        bu = @curve.call u

        # Pair-wise interpolation, trimming down dimensions
        iterate dim, 2 do |idx1|
          next if idx1.first == 1

          idx2 = idx1.dup
          idx2[0] = 1
          idx3 = idx1[1..-1]

          nf[idx3] = nf[idx1] + bu * (nf[idx2] - nf[idx1])
        end
        dim -= 1
      end
      (nf[[]] + 1) * 0.5
    end

  private
    def iterate dim, length, &block
      iterate_recursive dim, length, Array.new(dim, 0), &block
    end

    def iterate_recursive dim, length, idx, &block
      length.times do |i|
        idx[dim - 1] = i
        if dim == 1
          yield idx
        else
          iterate_recursive dim - 1, length, idx, &block
        end
      end
    end
  end#Noise
end#Perlin


#!/usr/bin/env ruby


class HeightMap
  attr_reader :width, :height
  def initialize(width, height)
    @grid = Array.new(height){Array.new(width){0}}
    @width = width
    @height = height
  end
  
  def get_grid()
    # Returns a copy of the current grid
    return Marshal::load(Marshal::dump(@grid))
  end
  
  def set_grid(value)
    # Sets all the cells in the grid to value
    @height.times() do |y|
      @width.times() do |x|
        set(x, y, value)
      end
    end
  end
  
  def get(x, y, out_of_bounds_height=0)
    # Returns the height at (x,y) if in bounds, otherwise out_of_bounds_height
    if x < 0 or y < 0 or x > @width - 1 or y > @height - 1 then
      return out_of_bounds_height
    else
      return @grid[y][x]
    end
  end
  
  def set(x, y, value)
    # Sets the height at (x, y) to value
    if x >= 0 and y >= 0 and x <= @width - 1 and y <= @height - 1 then
      @grid[y][x] = value
    end
  end
  
  def find_min()
    # Returns the minimum height in the grid
    min = get(0, 0)
    value = min
    @height.times() do |y|
      @width.times() do |x|
        value = get(x, y)
        min = value if value < min
      end
    end
    return min
  end
  
  def find_max()
    # Returns the maximum height in the grid
    max = get(0, 0)
    value = max
    @height.times() do |y|
      @width.times() do |x|
        value = get(x, y)
        max = value if value > max
      end
    end
    return max
  end
  
  def get_score(x, y)
    # Returns the sum of the 8 cells surrounding the cell (x, y)
    score = 0
    (-1..1).each() do |c|
      (-1..1).each() do |v|
        if c != 0 or v != 0 then
          score += get(x + c, y + v)
        end
      end
    end
    return score
  end
  
  def get_average_difference(x, y, max=6)
    # Averages the height of the surrounding cells- max of 6 both ways
    average_diff = (get_score(x, y) / 8.0).round() - get(x, y)
    if average_diff.abs() > max then
      if average_diff > 0 then
        return max
      else
        return -max
      end
    else
      return average_diff
    end
  end
  
  def get_cell_list()
    # Returns an array containing every coordinate in the grid
    array = []
    @height.times() do |y|
      @width.times() do |x|
        array << [x, y]
      end
    end
    return array
  end
  
  def calculate_new_height(x, y)
    # Returns the new height that a cell should be assigned
    average_difference = get_average_difference(x, y)
    possibility_array = [-1, 0, 1]
    average_difference.abs().times() do
      possibility_array << average_difference / average_difference.abs()
    end
    return possibility_array.shuffle().pop() + get(x, y)
  end
  
  def calculate_new_height_grid()
    # Randomly calculates each cell's height in the grid
    array = get_cell_list().shuffle()
    until array.empty?() do
      x, y = array.pop()
      set(x, y, calculate_new_height(x, y))
    end
  end
  
  def generate(generations)
    # Generates a heightmap with a given amount of generations
    if generations.to_i() >= 1 then
      generations.to_i().times() do
        calculate_new_height_grid()
      end
    end
  end
  
  def static(generations=20)
    # Generates random static on the grid
    if generations.to_i() >= 1 then
      set_grid(0)
      generations.to_i().times() do
        @height.times() do |y|
          @width.times() do |x|
            set(x, y, get(x, y) + [-1, 0, 1].shuffle().pop())
          end
        end
      end
    end
  end
  
  def average_grid_height()
    # Finds the average height of the cells, then subtracts the average from the cells
    sum = 0
    @height.times() do |y|
      @width.times() do |x|
        sum += get(x, y)
      end
    end
    average = (sum.to_f() / (@height * @width)).round()
    @height.times() do |y|
      @width.times() do |x|
        set(x, y, get(x, y) - average)
      end
    end
  end
  
  def save(filename)
    # Saves the current heightmap data to filename
    # TODO: Error handling
    File.open(filename, 'w+') do |file|
      file.print(Marshal::dump(@grid))
    end
  end
  
  def load(filename)
    # Loads filename as current heightmap
    # TODO: Error handling
    File.open(filename, 'r') do |file|
      @grid = Marshal::load(file.read())
    end
  end
  
  def smooth_grid(step=1, chances=2, list=get_cell_list().shuffle())
    # Smooths the grid
    until list.empty?() do
      x, y = list.pop()
      if rand(chances.to_i() + 1) != 0 then
        set(x, y, get_average_difference(x, y, step) + get(x, y))
      end
    end
  end
end
#~ @heightmap = HeightMap.new(80, 80)
#~ puts "heightmap made"
#~ @heightmap.generate(10)

#~ $sb = Sprite.new
#~ $sb.bitmap = Bitmap.new(Graphics.width, Graphics.height)

#~ def draw_square(window, x, y, z, width, height, color = Color.new(255,255,255))
#~   $sb.bitmap.fill_rect(x, y, width, height, color)
#~ end

#~ @tile_width = Graphics.width.to_f() / @heightmap.width
#~ @tile_height = Graphics.height.to_f() / @heightmap.height
#~ @grid = @heightmap.get_grid()


#~ def get_height_color(height)
#~     value = (10 * height) + 127
#~     if value > 255 then
#~       value = 255
#~     elsif value < 0 then
#~       value = 0
#~     end
#~     if height >= 0 then
#~       #puts "this is the value #{value}"
#~       return Color.new(0, value, 0, 255)
#~     else
#~       
#~       return Color.new(0, 0, value, 255)
#~     end
#~   end
#~ @grid.each_with_index() do |row, y|
#~         row.each_with_index do |height, x|
#~           draw_square(self, x * @tile_width, y * @tile_height, 1, @tile_width, @tile_height, get_height_color(height))
#~         end
#~       end
#~       
#~ $sb.z = 999999999
#~ puts "heightmap ended"

