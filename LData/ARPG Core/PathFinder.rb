#-------------------------------------------------------------------------------
# * [ACE] Khas Pathfinder
#-------------------------------------------------------------------------------
# * By Khas Arcthunder - arcthunder.site40.net
# * Version: 1.0 EN
# * Released on: 28/02/2012
#
#-------------------------------------------------------------------------------
# * Terms of Use
#-------------------------------------------------------------------------------
# When using any Khas script, you agree with the following terms:
# 1. You must give credit to Khas;
# 2. All Khas scripts are licensed under a Creative Commons license;
# 3. All Khas scripts are for non-commercial projects. If you need some script 
#    for your commercial project (I accept requests for this type of project), 
#    send an email to nilokruch@live.com with your request;
# 4. All Khas scripts are for personal use, you can use or edit for your own 
#    project, but you are not allowed to post any modified version;
# 5. You can’t give credit to yourself for posting any Khas script;
# 6. If you want to share a Khas script, don’t post the script or the direct 
#    download link, please redirect the user to arcthunder.site40.net
# 7. You are not allowed to convert any of Khas scripts to another engine, 
#    such converting a RGSS3 script to RGSS2 or something of that nature.
# 
# Check all terms at http://arcthunder.site40.net/terms/
#
#-------------------------------------------------------------------------------
# * Features
#-------------------------------------------------------------------------------
# Smart pathfinding
# Fast Algorithm
# Easy to use
# Plug'n'Play
# Game_Character objects compatible
# Log tool
#
#-------------------------------------------------------------------------------
# * Instructions
#-------------------------------------------------------------------------------
# Use the following code inside the "Call Script" box:
# 
# find_path(id,fx,fy)
# Runs the pathfinder.
# id => An integer, use -1 for game player, 0 for the event that the command
# will be called and X for event ID X.
# fx => X destination
# fy => Y destination
#
# find_path(id,fx,fy,true)
# Call this command if you want the game to wait the moving character.
#
# If you want to enable Pathfinder's logs, set "Log" constant to true.
#
#-------------------------------------------------------------------------------
# * Register
#-------------------------------------------------------------------------------
$khas_awesome = [] if $khas_awesome.nil?
$khas_awesome << ["Pathfinder",1.0]
#-------------------------------------------------------------------------------
# * Script
#-------------------------------------------------------------------------------
class Game_Interpreter
  def find_path(char,fx,fy,wait=false)
    $game_map.refresh if $game_map.need_refresh
    character = get_character(char)
    return if character.nil?
    return unless Path_Core.runnable?(character,fx,fy)
    path = Path_Core.run(character,fx,fy)
    return if path.nil?
    route = RPG::MoveRoute.new
    route.repeat = false
    route.wait = wait
    route.skippable = true
    route.list = []
    path << 0x00
    path.each { |code| route.list << RPG::MoveCommand.new(code)}
    character.force_move_route(route)
    @moving_character = character if wait
  end
end
class Path
  attr_accessor :axis
  attr_accessor :from
  attr_accessor :cost
  attr_accessor :dir
  def initialize(x,y,f,c,d)
    @axis = [x,y]
    @from = f
    @cost = c
    @dir = d
  end
end
module Path_Core
  Log = true
  Directions = {[1,0] => 3,[-1,0] => 2,[0,-1] => 4,[0,1] => 1}
  def self.runnable?(char,x,y)
    return false unless $game_map.valid?(x,y)
    return false if char.collide_with_characters?(x,y)
    $game_map.all_tiles(x,y).each { |id|
    flag = $game_map.tileset.flags[id]
    next if flag & 0x10 != 0
    return flag & 0x0f != 0x0f}
    return false
  end
  def self.run(char,fx,fy)
    return nil if char.x == fx && char.y == fy
    st = Time.now
    @char = char
    @start = Path.new(@char.x,@char.y,nil,0,nil)
    @finish = Path.new(fx,fy,nil,0,nil)
    @list = []
    @queue = []
    @preference = ((@char.x-fx).abs > (@char.y-fy).abs ? 0x0186aa : 0x01d)
    class << @list
      def new_path?(path_class)
        for path in self
          return false if path.axis == path_class.axis
        end
        return true
      end
    end
    class << @queue
      def new_path?(path_class)
        for path in self
          return false if path.axis == path_class.axis
        end
        return true
      end
    end
    if @preference & 0x02 == 0x02
      @queue << Path.new(@char.x,@char.y+1,@start,1,[0,1]) if @char.passable?(@char.x,@char.y,2)
      @queue << Path.new(@char.x,@char.y-1,@start,1,[0,-1]) if @char.passable?(@char.x,@char.y,8)
      @queue << Path.new(@char.x+1,@char.y,@start,1,[1,0]) if @char.passable?(@char.x,@char.y,6)
      @queue << Path.new(@char.x-1,@char.y,@start,1,[-1,0]) if @char.passable?(@char.x,@char.y,4)
      @list << @start
      loop do
        break if @queue.empty?
        @cpath = @queue[0]
        if @cpath.axis == @finish.axis
          @finish.cost = @cpath.cost
          @finish.from = @cpath
          break
        end
        @list << @cpath
        @path_array = []
        p1 = Path.new(@cpath.axis[0]+1,@cpath.axis[1],@cpath,@cpath.cost+1,[1,0])
        p2 = Path.new(@cpath.axis[0]-1,@cpath.axis[1],@cpath,@cpath.cost+1,[-1,0])
        p3 = Path.new(@cpath.axis[0],@cpath.axis[1]+1,@cpath,@cpath.cost+1,[0,1])
        p4 = Path.new(@cpath.axis[0],@cpath.axis[1]-1,@cpath,@cpath.cost+1,[0,-1])
        @path_array << p3 if @char.passable?(@cpath.axis[0],@cpath.axis[1],2) && @list.new_path?(p3) && @queue.new_path?(p3)
        @path_array << p4 if @char.passable?(@cpath.axis[0],@cpath.axis[1],8) && @list.new_path?(p4) && @queue.new_path?(p4)
        @path_array << p1 if @char.passable?(@cpath.axis[0],@cpath.axis[1],6) && @list.new_path?(p1) && @queue.new_path?(p1)
        @path_array << p2 if @char.passable?(@cpath.axis[0],@cpath.axis[1],4) && @list.new_path?(p2) && @queue.new_path?(p2)
        @path_array.each { |path| @queue << path }
        @queue.delete(@cpath)
      end
    else
      @queue << Path.new(@char.x+1,@char.y,@start,1,[1,0]) if @char.passable?(@char.x,@char.y,6)
      @queue << Path.new(@char.x-1,@char.y,@start,1,[-1,0]) if @char.passable?(@char.x,@char.y,4)
      @queue << Path.new(@char.x,@char.y+1,@start,1,[0,1]) if @char.passable?(@char.x,@char.y,2)
      @queue << Path.new(@char.x,@char.y-1,@start,1,[0,-1]) if @char.passable?(@char.x,@char.y,8)
      @list << @start
      loop do
        break if @queue.empty?
        @cpath = @queue[0]
        if @cpath.axis == @finish.axis
          @finish.cost = @cpath.cost
          @finish.from = @cpath
          break
        end
        @list << @cpath
        @path_array = []
        p1 = Path.new(@cpath.axis[0]+1,@cpath.axis[1],@cpath,@cpath.cost+1,[1,0])
        p2 = Path.new(@cpath.axis[0]-1,@cpath.axis[1],@cpath,@cpath.cost+1,[-1,0])
        p3 = Path.new(@cpath.axis[0],@cpath.axis[1]+1,@cpath,@cpath.cost+1,[0,1])
        p4 = Path.new(@cpath.axis[0],@cpath.axis[1]-1,@cpath,@cpath.cost+1,[0,-1])
        @path_array << p1 if @char.passable?(@cpath.axis[0],@cpath.axis[1],6) && @list.new_path?(p1) && @queue.new_path?(p1)
        @path_array << p2 if @char.passable?(@cpath.axis[0],@cpath.axis[1],4) && @list.new_path?(p2) && @queue.new_path?(p2)
        @path_array << p3 if @char.passable?(@cpath.axis[0],@cpath.axis[1],2) && @list.new_path?(p3) && @queue.new_path?(p3)
        @path_array << p4 if @char.passable?(@cpath.axis[0],@cpath.axis[1],8) && @list.new_path?(p4) && @queue.new_path?(p4)
        @path_array.each { |path| @queue << path }
        @queue.delete(@cpath)
      end
    end
    if @finish.from.nil?
      return nil
    else
      steps = [@finish.from]
      loop do
        cr = steps[-1]
        if cr.cost == 1
          @result = []
          steps.each { |s| @result << Directions[s.dir]}
          break
        else
          steps << cr.from
        end
      end
      self.print_log(Time.now-st) if Log
      return @result.reverse
    end
  end
  def self.print_log(time)
    print "\n--------------------\n"
    print "Khas Pathfinder\n"
    print "Time: #{time}\n"
    print "Size: #{@result.size}\n"
    print "--------------------\n"
  end
end