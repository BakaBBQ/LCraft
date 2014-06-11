#==============================================================================
# ** Victor Engine - Pixel Movement
#------------------------------------------------------------------------------
# Author : Victor Sant
#
# Version History:
#  v 1.00 - 2012.05.29 > First release
#  v 1.01 - 2012.05.29 > Compatibility with Terrain States
#  v 1.02 - 2012.07.03 > Compatibility with Basic Module 1.23
#  v 1.03 - 2012.07.05 > Added 'over event' tag for objects over blocked tiles
#                      > Added Steps settings for events
#  v 1.04 - 2012.07.24 > Compatibility with Moving Platform
#                      > Added <each step trigger> tag for events
#  v 1.05 - 2012.07.30 > Fixed issue when characters moves toward the same spot
#  v 1.06 - 2012.08.03 > Compatibility with Anti Lag
#  v 1.07 - 2012.08.03 > Fixed collision with tile graphics events
#  v 1.08 - 2012.08.18 > Fixed issue with Pixel Movement and Vehicles
#                      > Fixed issue with some notetags
#                      > Fixed issue with chasing events
#  v 1.09 - 2013.01.07 > Fixed issue with vehicles passing through all tiles
#  v 1.10 - 2013.01.24 > Fixed issue with diagonal movement and VE_DIAGONAL_FIX
#------------------------------------------------------------------------------
#  This script allows to replace the tile based movement where the player
# walks a whole 32 pixel tile each step with one that he walks only 4 pixels.
# It also give a better collision system for events.
#------------------------------------------------------------------------------
# Compatibility
#   Requires the script 'Victor Engine - Basic Module' v 1.25 or higher
#   If used with 'Victor Engine - Animated Battle' place this bellow it.
#   If used with 'Victor Engine - Follower Control' place this bellow it.
#   If used with 'Victor Engine - Follower Options' place this bellow it.
#
# * Overwrite methods
#   class Game_Actor < Game_Battler
#     def turn_end_on_map
#
#   class Game_Map
#     def layered_tiles(x, y)
#     def events_xy(x, y)
#     def events_xy_nt(x, y)
#     def x_with_direction(x, d, times = 1)
#     def y_with_direction(y, d, times = 1)
#     def round_x_with_direction(x, d)
#     def round_y_with_direction
#
#   class Game_CharacterBase
#     def region_id
#     def move_straight(d, turn_ok = true)
#     def move_diagonal(horz, vert)
#     def collide_with_events?(x, y)
#     def collide_with_vehicles?(x, y)
#
#   class Game_Player < Game_Character
#     def check_event_trigger_there(triggers)
#     def start_map_event(x, y, triggers, normal)
#     def update_nonmoving(last_moving)
#     def get_on_vehicle
#     def increase_steps
#
#   class Game_Follower < Game_Character
#     def chase_preceding_character
#
#   class Game_Event < Game_Character
#     def collide_with_player_characters?(x, y)
#
#   class Game_Vehicle < Game_Character
#     def land_ok?(x, y, d)
#
# * Alias methods
#   class Game_Actor < Game_Battler
#     def check_floor_effect
#
#   class Game_CharacterBase
#     def init_public_members
#     def update
#
#   class Game_Event < Game_Character
#     def start
#
#   class Game_Player < Game_Character
#     def get_off_vehicle
#     def clear_transfer_info
#     def update
#
#   class Game_Event < Game_Character
#     def start
#
#------------------------------------------------------------------------------
# Instructions:
#  To instal the script, open you script editor and paste this script on
#  a new section bellow the Materials section. This script must also
#  be bellow the script 'Victor Engine - Basic'
#
#------------------------------------------------------------------------------
# Event Comment boxes note tags:
#   Tags to be used on events Comment boxes.
#
#  <move steps: x>
#   Setup the number of steps each "Move" command will execute. The default
#   value is 8 (1 tile)
#     x : number of steps
#
#  <event size: x, y>
#   Collision area size, in pixels for event collisions.
#     x : collision area width
#     y : collision area height
#
#  <front collision>
#   Events with this tag won't start if the the collision between events and
#   the player occur between their edges.
#
#  <no side collision fix>
#   Events with this tag won't have the "slide" effect when the edges of the
#   events collide with the player
#
#  <over tile>
#   Events with this tag will start even when placed over blocked tiles.
#   By default, if the passage is blocked the event don't start.
#
#  <each step trigger>
#   By default, events with through or bellow character priority triggers
#   only one time for each 8 steps above them. With this tag though, the
#   event will trigger every step.
#
#------------------------------------------------------------------------------
# Additional instructions:
#
#  All events and tiles have a "slide" effect when the player faces the edge
#  of a tile or event. I added this function since it would be a pain to
#  be in the exact position to go throug a narrow path.
#  This can be disabled for events, but not for tiles.
#
#  By default, event collision size is the same as the event bitmap box, no
#  matter how the sprite is set inside of the box. If you want different
#  collision size you must setup manually in the event with the tag
#  <event size: x, y>
#
#  Events over blocked tiles will not start properly unless the event have
#  the tag <over tile>
#
#==============================================================================

#==============================================================================
# ** Victor Engine
#------------------------------------------------------------------------------
#   Setting module for the Victor Engine
#==============================================================================

module Victor_Engine
  #--------------------------------------------------------------------------
  # * Player collision area
  #   Different from events, player collision don't rely on the graphic size
  #   Player collision area can be of 2 types:
  #   - 32 x 32 box if VE_PLAYER_BIG_COLLISION = true
  #   - 24 x 24 box if VE_PLAYER_BIG_COLLISION = false
  #--------------------------------------------------------------------------
  VE_PLAYER_BIG_COLLISION = false
  #--------------------------------------------------------------------------
  # * required
  #   This method checks for the existance of the basic module and other
  #   VE scripts required for this script to work, don't edit this
  #--------------------------------------------------------------------------
  def self.required(name, req, version, type = nil)
    if !$imported[:ve_basic_module]
      msg = "The script '%s' requires the script\n"
      msg += "'VE - Basic Module' v%s or higher above it to work properly\n"
      msg += "Go to http://victorscripts.wordpress.com/ to download this script."
      msgbox(sprintf(msg, self.script_name(name), version))
      exit
    else
      self.required_script(name, req, version, type)
    end
  end
  #--------------------------------------------------------------------------
  # * script_name
  #   Get the script name base on the imported value
  #--------------------------------------------------------------------------
  def self.script_name(name, ext = "VE")
    name = name.to_s.gsub("_", " ").upcase.split
    name.collect! {|char| char == ext ? "#{char} -" : char.capitalize }
    name.join(" ")
  end
end

$imported ||= {}
$imported[:ve_pixel_movement] = 1.10
Victor_Engine.required(:ve_pixel_movement, :ve_basic_module, 1.25, :above)
Victor_Engine.required(:ve_pixel_movement, :ve_map_battle, 1.00, :bellow)
Victor_Engine.required(:ve_pixel_movement, :ve_diagonal_move, 1.00, :bellow)

#==============================================================================
# ** Game_Actor
#------------------------------------------------------------------------------
#  This class handles actors. It's used within the Game_Actors class
# ($game_actors) and referenced by the Game_Party class ($game_party).
#==============================================================================

class Game_Actor < Game_Battler
  #--------------------------------------------------------------------------
  # * Overwrite method: turn_end_on_map
  #--------------------------------------------------------------------------
  def turn_end_on_map
    if $game_player.steps % (steps_for_turn * 8) == 0
      on_turn_end
      perform_map_damage_effect if @result.hp_damage > 0
    end
  end
  #--------------------------------------------------------------------------
  # * Alias method: init_public_members
  #--------------------------------------------------------------------------
  alias :check_floor_effect_ve_pixel_movement :check_floor_effect
  def check_floor_effect
    return if check_damage_floor
    check_floor_effect_ve_pixel_movement
  end
  #--------------------------------------------------------------------------
  # * New method: check_damage_floor
  #--------------------------------------------------------------------------
  def check_damage_floor
    $game_player.damage_floor % 8 != 0
  end
end

#==============================================================================
# ** Game_Map
#------------------------------------------------------------------------------
#  This class handles maps. It includes scrolling and passage determination
# functions. The instance of this class is referenced by $game_map.
#==============================================================================

class Game_Map
  #--------------------------------------------------------------------------
  # * Overwrite method: layered_tiles
  #--------------------------------------------------------------------------
  def layered_tiles(x, y)
    x2 = (x - 0.5).ceil
    y2 = (y - 0.125).ceil
    [2, 1, 0].collect {|z| tile_id(x2, y2, z) }
  end
  #--------------------------------------------------------------------------
  # * Overwrite method: events_xy
  #--------------------------------------------------------------------------
  def events_xy(x, y)
    event_list.select {|event| event.near?(x, y) }
  end
  #--------------------------------------------------------------------------
  # * Overwrite method: events_xy_nt
  #--------------------------------------------------------------------------
  def events_xy_nt(x, y)
    event_list.select {|event| event.near_nt?(x, y) }
  end
  #--------------------------------------------------------------------------
  # * Overwrite method: x_with_direction
  #--------------------------------------------------------------------------
  def x_with_direction(x, d, times = 1)
    x + (d == 6 ? times * 0.125 : d == 4 ? -times * 0.125 : 0)
  end
  #--------------------------------------------------------------------------
  # * Overwrite method: y_with_direction
  #--------------------------------------------------------------------------
  def y_with_direction(y, d, times = 1)
    y + (d == 2 ? times * 0.125 : d == 8 ? -times * 0.125 : 0)
  end
  #--------------------------------------------------------------------------
  # * Overwrite method: round_x_with_direction
  #--------------------------------------------------------------------------
  def round_x_with_direction(x, d)
    round_x(x + (d == 6 ? 0.125 : d == 4 ? -0.125 : 0))
  end
  #--------------------------------------------------------------------------
  # * Overwrite method: round_y_with_direction
  #--------------------------------------------------------------------------
  def round_y_with_direction(y, d)
    round_y(y + (d == 2 ? 0.125 : d == 8 ? -0.125 : 0))
  end
  #--------------------------------------------------------------------------
  # * New method: check_x_with_direction
  #--------------------------------------------------------------------------
  def check_x_with_direction(x, d)
    round_x(x + (d == 6 ? 1 : d == 4 ? -1 : 0))
  end
  #--------------------------------------------------------------------------
  # * New method: check_y_with_direction
  #--------------------------------------------------------------------------
  def check_y_with_direction(y, d)
    round_y(y + (d == 2 ? 1 : d == 8 ? -1 : 0))
  end
end

#==============================================================================
# ** Game_CharacterBase
#------------------------------------------------------------------------------
#  This class deals with characters. Common to all characters, stores basic
# data, such as coordinates and graphics. It's used as a superclass of the
# Game_Character class.
#==============================================================================

class Game_CharacterBase
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :next_movement
  attr_accessor :side_collision
  attr_accessor :damage_floor
  attr_accessor :move_list
  attr_accessor :steps
  #--------------------------------------------------------------------------
  # * Overwrite method: region_id
  #--------------------------------------------------------------------------
  def region_id
    $game_map.region_id((@x - 0.5).ceil, (@y - 0.125).ceil)
  end
  #--------------------------------------------------------------------------
  # * Overwrite method: collide_with_events?
  #--------------------------------------------------------------------------
  def collide_with_events?(x, y)
    $game_map.events_xy_nt(x, y).any? do |event|
      event.collision_condition?(x, y, bw, bh, event?, @id, @side_collision)
    end
  end
  #--------------------------------------------------------------------------
  # * Overwrite method: collide_with_vehicles?
  #--------------------------------------------------------------------------
  def collide_with_vehicles?(x, y)
    $game_map.vehicles.compact.any? do |vehicle|
      next if vehicle.map_id != $game_map.map_id
      vehicle.collision_condition?(x, y, bw, bh, self)
    end
  end
  #--------------------------------------------------------------------------
  # * Overwrite method: move_straight
  #--------------------------------------------------------------------------
  def move_straight(d, turn_ok = true)
    @move_list += [{d: [d], turn: turn_ok}] * step_times
  end
  #--------------------------------------------------------------------------
  # * Overwrite method: move_straight
  #--------------------------------------------------------------------------
  def move_diagonal(horz, vert)
    @move_list += [{d: [horz, vert], turn: true}] * step_times
  end
  #--------------------------------------------------------------------------
  # * Alias method: init_public_members
  #--------------------------------------------------------------------------
  alias :init_public_members_ve_pixel_movement :init_public_members
  def init_public_members
    init_public_members_ve_pixel_movement
    @move_list     = []
    @next_movement = []
    @over_event    = 0
    @damage_floor  = 0
    @steps         = 0
  end
  #--------------------------------------------------------------------------
  # * Alias method: update
  #--------------------------------------------------------------------------
  alias :update_ve_pixel_movement :update
  def update
    update_move_straight
    update_move_diagonal
    update_ve_pixel_movement
  end
  #--------------------------------------------------------------------------
  # * New method: update_move_straight
  #--------------------------------------------------------------------------
  def update_move_straight
    return if moving? || @move_list.empty?
    return if @move_list.first[:d].size > 1
    @move_value = @move_list.shift
    d           = @move_value[:d].first
    if passable?(@x, @y, d)
      move_straight_pixel(d)
    elsif @move_value[:turn]
      @move_list.clear
      check_event_trigger_move(d)
    else
      @move_list.clear
    end
  end
  #--------------------------------------------------------------------------
  # * New method: move_straight_pixel
  #--------------------------------------------------------------------------
  def move_straight_pixel(d)
    @diagonal_move = false
    setup_movement(d, d)
    @real_x = $game_map.x_with_direction(@x, reverse_dir(d))
    @real_y = $game_map.y_with_direction(@y, reverse_dir(d))
    @moved  = player?
  end
  #--------------------------------------------------------------------------
  # * Overwrite method: update_move_diagonal
  #--------------------------------------------------------------------------
  def update_move_diagonal
    return if moving? || @move_list.empty?
    return if @move_list.first[:d].size < 2
    @move_value = @move_list.shift
    horz        = @move_value[:d].first
    vert        = @move_value[:d].last
    move_diagonal_pixel(horz, vert) if diagonal_passable?(x, y, horz, vert)
  end
  #--------------------------------------------------------------------------
  # * New method: move_diagonal_pixel
  #--------------------------------------------------------------------------
  def move_diagonal_pixel(horz, vert)
    @diagonal_move = true
    setup_movement(horz, vert)
    @real_x = $game_map.x_with_direction(@x, reverse_dir(horz))
    @real_y = $game_map.y_with_direction(@y, reverse_dir(vert))
    @moved = player?
  end
  #--------------------------------------------------------------------------
  # * New method: character_collision?
  #--------------------------------------------------------------------------
  def character_collision?(x, y, d)
    x2 = $game_map.round_x_with_direction(x, d)
    y2 = $game_map.round_y_with_direction(y, d)
    @through || debug_through? || !collide_with_characters?(x2, y2)
  end
  #--------------------------------------------------------------------------
  # * New method: step_times
  #--------------------------------------------------------------------------
  def step_times
    return 8
  end
  #--------------------------------------------------------------------------
  # * New method: near_nt?
  #--------------------------------------------------------------------------
  def near_nt?(x, y)
    near?(x, y) && !@through
  end
  #--------------------------------------------------------------------------
  # * New method: near?
  #--------------------------------------------------------------------------
  def near?(x, y)
    w = step_over? ? [bw * 0.625, 0.5].max : [bw, 1.0].max 
    h = step_over? ? [bh * 0.625, 0.5].max : [bh, 1.0].max 
    @real_x > x - w && @real_x < x + w && @real_y > y - h && @real_y < y + h
  end
  #--------------------------------------------------------------------------
  # * New method: setup_movement
  #--------------------------------------------------------------------------
  def setup_movement(horz, vert)
    @x = $game_map.round_x_with_direction(@x, horz)
    @y = $game_map.round_y_with_direction(@y, vert)
    add_next_movement(horz == vert ? horz : [horz, vert])
    set_direction(horz) if @direction == reverse_dir(horz) || horz == vert
    set_direction(vert) if @direction == reverse_dir(vert) && horz != vert
    follower_control_move_update(horz, vert)
    increase_steps
  end
  #--------------------------------------------------------------------------
  # * New method: check_event_trigger_move
  #--------------------------------------------------------------------------
  def check_event_trigger_move(d)
    set_direction(d)
    check_event_trigger_touch_front
  end
  #--------------------------------------------------------------------------
  # * New method: collision_condition?
  #--------------------------------------------------------------------------
  def collision_condition?(x, y, bw, bh, event, event_id, side)
    return false if event && self.id == event_id
    return false unless collision?(x, y, bw, bh)
    return false unless normal_priority? || event
    return false if side && !side_collision?
    return true
  end
  #--------------------------------------------------------------------------
  # * New method: follower_control_move_update
  #--------------------------------------------------------------------------
  def follower_control_move_update(horz, vert)
    return unless $imported[:ve_followers_options] 
    return unless player? || follower?
    add_move_update(horz == vert ? [horz] : [horz, vert])
  end
  #--------------------------------------------------------------------------
  # * New method: passable?
  #--------------------------------------------------------------------------
  def passable?(x, y, d)
    x = fix_position(x)
    y = fix_position(y)
    passable1 = passable_tile?(x, y, d)
    passable2 = character_collision?(x, y, d)
    fix_movement(x, y, d)  if player? && !passable1 && passable2
    fix_collision(x, y, d) if player? && !passable2 && passable1
    passable1 && passable2
  end
  #--------------------------------------------------------------------------
  # * New method: passable_tile?
  #--------------------------------------------------------------------------
  def passable_tile?(x, y, d)
    result = true
    result = passable_down?(x, y)  if d == 2
    result = passable_left?(x, y)  if d == 4
    result = passable_right?(x, y) if d == 6
    result = passable_up?(x, y)    if d == 8
    result
  end
  #--------------------------------------------------------------------------
  # * New method: locked_tile?
  #--------------------------------------------------------------------------
  def locked_tile?(x, y, d = 0)
    list = [2, 4, 6, 8] - [d]
    list.all? {|d| !map_passable?(x, y, d) }
  end
  #--------------------------------------------------------------------------
  # * New method: locked_move?
  #--------------------------------------------------------------------------
  def locked_move?(x, y)
    !passable_down?(x, y)  && !passable_left?(x, y)
    !passable_right?(x, y) && !passable_up?(x, y)
  end
  #--------------------------------------------------------------------------
  # * New method: passable_down?
  #--------------------------------------------------------------------------
  def passable_down?(x, y)
    passable_normal?(x.ceil, y.to_i, 2, 4, x.ceil?) &&
    passable_normal?(x.to_i, y.to_i, 2, 6, x.ceil?)
  end
  #--------------------------------------------------------------------------
  # * New method: passable_left?
  #--------------------------------------------------------------------------
  def passable_left?(x, y)
    passable_normal?(x.ceil, y.ceil, 4, 8, y.ceil?) &&
    passable_normal?(x.ceil, y.to_i, 4, 2, y.ceil?)
  end
  #--------------------------------------------------------------------------
  # * New method: passable_right?
  #--------------------------------------------------------------------------
  def passable_right?(x, y)
    passable_normal?(x.to_i, y.ceil, 6, 8, y.ceil?) &&
    passable_normal?(x.to_i, y.to_i, 6, 2, y.ceil?)
  end
  #--------------------------------------------------------------------------
  # * New method: passable_up?
  #--------------------------------------------------------------------------
  def passable_up?(x, y)
    passable_normal?(x.ceil, y.ceil, 8, 4, x.ceil?) && 
    passable_normal?(x.to_i, y.ceil, 8, 6, x.ceil?)
  end
  #--------------------------------------------------------------------------
  # * New method: passable_normal?
  #--------------------------------------------------------------------------
  def passable_normal?(x, y, d, d2, ceil = false)
    x1 = $game_map.round_x(x)
    y1 = $game_map.round_y(y)
    x2 = $game_map.check_x_with_direction(x1, d)
    y2 = $game_map.check_y_with_direction(y1, d)
    x3 = $game_map.round_x_with_direction(x1, d)
    y3 = $game_map.round_y_with_direction(y1, d)
    return false unless $game_map.valid?(x3, y3)
    return true  if @through || debug_through?
    return false unless map_passable?(x2, y2, d2) || !ceil
    return false unless move_passable1?(x1, y1, x2, y2, d)
    return false unless move_passable2?(x1, y1, x2, y2, d)
    return true
  end
  #--------------------------------------------------------------------------
  # * New method: move_passable1?
  #--------------------------------------------------------------------------
  def move_passable1?(x1, y1, x2, y2, d)
    map_passable?(x1, y1, d) || map_passable?(x2, y2, d)
  end
  #--------------------------------------------------------------------------
  # * New method: move_passable?
  #--------------------------------------------------------------------------
  def move_passable2?(x1, y1, x2, y2, d)
    map_passable?(x2, y2, reverse_dir(d)) && (map_passable?(x1, y1, d) ||
    locked_tile?(x1, y1))
  end
  #--------------------------------------------------------------------------
  # * New method: fix_movement
  #--------------------------------------------------------------------------
  def fix_movement(x, y, d)
    return if (@diagonal && @diagonal != 0) || @diagonal_move
    fix_movement_horiz(x, y, d) if (d == 2 || d == 8) && x.ceil?
    fix_movement_vert(x, y, d)  if (d == 4 || d == 6) && y.ceil?
  end
  #--------------------------------------------------------------------------
  # * New method: fix_movement_horiz
  #--------------------------------------------------------------------------
  def fix_movement_horiz(x, y, d)
    adjust = x - x.to_i
    fix_move_straight(4) if fix_movement_left?(x, y, d)  && adjust < 0.5
    fix_move_straight(6) if fix_movement_right?(x, y, d) && adjust > 0.5
  end
  #--------------------------------------------------------------------------
  # * New method: fix_movement_ver
  #--------------------------------------------------------------------------
  def fix_movement_vert(x, y, d)
    adjust = y - y.to_i
    fix_move_straight(2) if fix_movement_down?(x, y, d) && adjust > 0.5
    fix_move_straight(8) if fix_movement_up?(x, y, d)   && adjust < 0.5
  end
  #--------------------------------------------------------------------------
  # * New method: fix_movement_down?
  #--------------------------------------------------------------------------
  def fix_movement_down?(x, y, d)
    passable_normal?(x.to_i, y.ceil, d, 0, false) && movement_fix?(x, y, 2)
  end
  #--------------------------------------------------------------------------
  # * New method: fix_movement_left?
  #--------------------------------------------------------------------------
  def fix_movement_left?(x, y, d)
    passable_normal?(x.to_i, y.to_i, d, 0, false) && movement_fix?(x, y, 4)
  end
  #--------------------------------------------------------------------------
  # * New method: fix_movement_right?
  #--------------------------------------------------------------------------
  def fix_movement_right?(x, y, d)
    passable_normal?(x.ceil, y.to_i, d, 0, false) && movement_fix?(x, y, 6)
  end
  #--------------------------------------------------------------------------
  # * New method: fix_movement_up?
  #--------------------------------------------------------------------------
  def fix_movement_up?(x, y, d)
    passable_normal?(x.to_i, y.to_i, d, 0, false) && movement_fix?(x, y, 8)
  end
  #--------------------------------------------------------------------------
  # * New method: movement_fix?
  #--------------------------------------------------------------------------
  def movement_fix?(x, y, d)
    passable_tile?(x, y, d) && character_collision?(x, y, d)
  end
  #--------------------------------------------------------------------------
  # * New method: fix_collision
  #--------------------------------------------------------------------------
  def fix_collision(x, y, d)
    return if (@diagonal && @diagonal != 0) || @diagonal_move
    @side_collision = true
    fix_collision_horiz(x, y, d) if (d == 2 || d == 8)
    fix_collision_vert(x, y, d)  if (d == 4 || d == 6)
    @side_collision = false
  end
  #--------------------------------------------------------------------------
  # * New method: fix_collision_horiz
  #--------------------------------------------------------------------------
  def fix_collision_horiz(x, y, d)
    fix_move_straight(4) if fix_collision_left?(x, y, d)
    fix_move_straight(6) if fix_collision_right?(x, y, d)
  end
  #--------------------------------------------------------------------------
  # * New method: fix_collision_vert
  #--------------------------------------------------------------------------
  def fix_collision_vert(x, y, d)
    fix_move_straight(2) if fix_collision_down?(x, y, d)
    fix_move_straight(8) if fix_collision_up?(x, y, d)
  end
  #--------------------------------------------------------------------------
  # * New method: fix_collision_down?
  #--------------------------------------------------------------------------
  def fix_collision_down?(x, y, d)
    !character_collision?(x, y, d) && collision_fix?(x, y, d, 2)
  end
  #--------------------------------------------------------------------------
  # * New method: fix_collision_left?
  #--------------------------------------------------------------------------
  def fix_collision_left?(x, y, d)
    !character_collision?(x, y, d) && collision_fix?(x, y, d,  4)
  end
  #--------------------------------------------------------------------------
  # * New method: fix_collision_right?
  #--------------------------------------------------------------------------
  def fix_collision_right?(x, y, d)
    !character_collision?(x, y, d) && collision_fix?(x, y, d, 6)
  end
  #--------------------------------------------------------------------------
  # * New method: fix_collision_up?
  #--------------------------------------------------------------------------
  def fix_collision_up?(x, y, d)
    !character_collision?(x, y, d) && collision_fix?(x, y, d, 8)
  end
  #--------------------------------------------------------------------------
  # * New method: collision_fix?
  #--------------------------------------------------------------------------
  def collision_fix?(x, y, d, d2)
    side_collision_fix?(x, y, d, d2, 2) && side_fix?(x, y, d2)
  end
  #--------------------------------------------------------------------------
  # * New method: side_collision_fix?
  #--------------------------------------------------------------------------
  def side_collision_fix?(x, y, d, d2, t)
    t.times.any? do |i|
      x2, y2 = x, y
      y2 += (t - i) * 0.125 if d2 == 2
      x2 -= (t - i) * 0.125 if d2 == 4
      x2 += (t - i) * 0.125 if d2 == 6
      y2 -= (t - i) * 0.125 if d2 == 8
      character_collision?(x2, y2, d)
    end
  end
  #--------------------------------------------------------------------------
  # * New method: side_fix?
  #--------------------------------------------------------------------------
  def side_fix?(x, y, d)
    passable_tile?(x, y, d) && character_collision?(x, y, d)
  end
  #--------------------------------------------------------------------------
  # * New method: fix_move_straight
  #--------------------------------------------------------------------------
  def fix_move_straight(d)
    return if moving?
    @x = $game_map.round_x_with_direction(@x, d)
    @y = $game_map.round_y_with_direction(@y, d)
    follower_control_move_update(d, d)
    add_next_movement(d)
    increase_steps
    @moved = player?
  end
  #--------------------------------------------------------------------------
  # * New method: add_next_movement
  #--------------------------------------------------------------------------
  def add_next_movement(d)
    return unless follower? || player? 
    return if $imported[:ve_followers_control]# && follower_control_block
    @next_movement.push(d)
  end
  #--------------------------------------------------------------------------
  # * New method: follower_control_block
  #--------------------------------------------------------------------------
  def follower_control_block
    return true if follower? && origin_position
    return true if $game_player.followers.gathering_origin?
    return false
  end
  #--------------------------------------------------------------------------
  # * New method: front_collision?
  #--------------------------------------------------------------------------
  def front_collision?(x, y, d)
    return false if (@diagonal && @diagonal != 0) || @diagonal_move
    result = !front_collision_horiz(x, y, d) if (d == 2 || d == 8)
    result = !front_collision_vert(x, y, d)  if (d == 4 || d == 6)
    result
  end
  #--------------------------------------------------------------------------
  # * New method: front_collision_horiz
  #--------------------------------------------------------------------------
  def front_collision_horiz(x, y, d)
    side_collision_fix?(x, y, d, 4, 4) || side_collision_fix?(x, y, d, 6, 4) 
  end
  #--------------------------------------------------------------------------
  # * New method: front_collision_vert
  #--------------------------------------------------------------------------
  def front_collision_vert(x, y, d)
    side_collision_fix?(x, y, d, 2, 4) || side_collision_fix?(x, y, d, 8, 4)
  end
  #--------------------------------------------------------------------------
  # * New method: step_over?
  #--------------------------------------------------------------------------
  def step_over?
    @through
  end
  #--------------------------------------------------------------------------
  # * New method: bw
  #--------------------------------------------------------------------------
  def bw
    setup_bitmap_dimension unless @bw && character_name == @character_name_wh
    @bw
  end
  #--------------------------------------------------------------------------
  # * New method: bh
  #--------------------------------------------------------------------------
  def bh
    setup_bitmap_dimension unless @bh && character_name == @character_name_wh
    @bh
  end
  #--------------------------------------------------------------------------
  # * New method: setup_bitmap_dimension
  #--------------------------------------------------------------------------
  def setup_bitmap_dimension
    @character_name_wh = character_name
    bitmap = Cache.character(character_name).clone
    sign = @character_name[/^[\!\$]./]
    if character_name != "" && @tile_id == 0 && sign && sign.include?('$')
      @bw = bitmap.width  / 32.0 / frames
      @bh = bitmap.height / 32.0 / 4
    elsif character_name != "" && @tile_id == 0 
      @bw = bitmap.width  / 32.0 / (frames * 4) 
      @bh = bitmap.height / 32.0 / 8
    else
      @bw = 1.0
      @bh = 1.0
    end
    bitmap.dispose
  end
  #--------------------------------------------------------------------------
  # * New method: collision?
  #--------------------------------------------------------------------------
  def collision?(x, y, w, h)
    ax1, ay1, ax2, ay2 = setup_rect(x, y, w, h)
    bx1, by1, bx2, by2 = setup_rect(@x, @y, bw, bh)
    ax2 > bx1 && ax1 < bx2 && ay2 > by1 && ay1 < by2 
  end
  #--------------------------------------------------------------------------
  # * New method: over?
  #--------------------------------------------------------------------------
  def over?(x, y)
    ax1, ay1, ax2, ay2 = setup_rect(x, y - 0.125, 0, 0)
    bx1, by1, bx2, by2 = setup_rect(@real_x, @real_y, bw, bh - 0.125)
    ax2 >= bx1 && ax1 <= bx2 && ay2 >= by1 && ay1 <= by2
  end
  #--------------------------------------------------------------------------
  # * New method: setup_rect
  #--------------------------------------------------------------------------
  def setup_rect(x, y, w, h)
    x1 = x - w / 2.0
    y1 = y - h
    x2 = x1 + w
    y2 = y1 + h
    [x1, y1, x2, y2]
  end
  #--------------------------------------------------------------------------
  # * New method: align_with
  #--------------------------------------------------------------------------
  def align_with(x, y)
    d  = @direction
    @x = $game_map.round_x_with_direction(x, 0) if d == 2 || d == 8
    @y = $game_map.round_y_with_direction(y, 0) if d == 6 || d == 4
    dx = (d == 2 || d == 8) ? (@x - @real_x) / 0.125 : 0
    dy = (d == 4 || d == 6) ? (@y - @real_y) / 0.125 : 0
    set_direction(dx > 0 ? 6 : dx < 0 ? 4 : dy > 0 ? 2 : dy < 0 ? 8 : d)
    @real_x = $game_map.x_with_direction(@x, reverse_dir(@direction), dx.abs)
    @real_y = $game_map.y_with_direction(@y, reverse_dir(@direction), dy.abs)
    update_for_align while moving?
    @direction = d
  end
  #--------------------------------------------------------------------------
  # * New method: update_for_align
  #--------------------------------------------------------------------------
  def update_for_align
    SceneManager.scene.update_basic
    SceneManager.scene.spriteset.update
    $game_map.update(true)
    $game_timer.update
    update_animation
    update_move
  end
  #--------------------------------------------------------------------------
  # * New method: fix_position
  #--------------------------------------------------------------------------
  def fix_position(n)
    (n * 64 / 8).round / 8.0
  end
end

#==============================================================================
# ** Game_Player
#------------------------------------------------------------------------------
#  This class handles maps. It includes event starting determinants and map
# scrolling functions. The instance of this class is referenced by $game_map.
#==============================================================================

class Game_Player < Game_Character
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :over_event
  attr_accessor :land_test
  #--------------------------------------------------------------------------
  # * Overwrite method: check_event_trigger_there
  #--------------------------------------------------------------------------
  def check_event_trigger_there(triggers)
    x2 = $game_map.round_x_with_direction(@x, @direction)
    y2 = $game_map.round_y_with_direction(@y, @direction)
    start_map_event(x2, y2, triggers, true)
    return if $game_map.any_event_starting?
    return unless counter_tile?
    x3 = $game_map.check_x_with_direction(x2, @direction)
    y3 = $game_map.check_y_with_direction(y2, @direction)
    start_map_event(x3, y3, triggers, true)
  end
  #--------------------------------------------------------------------------
  # * Overwrite method: start_map_event
  #--------------------------------------------------------------------------
  def start_map_event(x, y, triggers, normal)
    return if $game_map.interpreter.running?
    $game_map.events_xy(x, y).each do |event|
      event.start if check_event_contiontion(x, y, event, triggers, normal)
    end
  end
  #--------------------------------------------------------------------------
  # * Overwrite method: update_nonmoving
  #--------------------------------------------------------------------------
  def update_nonmoving(last_moving)
    return if $game_map.interpreter.running?
    moved  = @moved
    @moved = false
    if last_moving || moved
      $game_party.on_player_walk
      return if check_touch_event
    end
    if movable? && Input.trigger?(:C)
      return if get_on_off_vehicle
      return if check_action_event
    end
    @over_event -= 1 if @over_event > 0 && (last_moving || moved)
    update_encounter if last_moving || moved
  end
  #--------------------------------------------------------------------------
  # * Overwrite method: get_on_vehicle
  #--------------------------------------------------------------------------
  def get_on_vehicle
    setup_vehicle
    enter_vehicle if vehicle
    @vehicle_getting_on
  end
  #--------------------------------------------------------------------------
  # * Overwrite method: increase_steps
  #--------------------------------------------------------------------------
  def increase_steps
    super
    if normal_walk?
      @steps += 1
      $game_player.damage_floor  = 0 unless on_damage_floor?
      $game_player.damage_floor += 1
      $game_party.increase_steps if @steps % 8 == 0
    end
  end
  #--------------------------------------------------------------------------
  # * Alias method: clear_transfer_info
  #--------------------------------------------------------------------------
  alias :clear_transfer_info_ve_pixel_movement :clear_transfer_info
  def clear_transfer_info
    clear_transfer_info_ve_pixel_movement
    clear_next_movement
  end
  #--------------------------------------------------------------------------
  # * Alias method: update
  #--------------------------------------------------------------------------
  alias :update_ve_gp_pixel_movement :update
  def update
    @followers.move unless $imported[:ve_followers_options]
    update_ve_gp_pixel_movement
  end
  #--------------------------------------------------------------------------
  # * Alias method: move_by_input
  #--------------------------------------------------------------------------
  alias :move_by_input_ve_gp_pixel_movement :move_by_input
  def move_by_input
    return unless @move_list.empty?
    move_by_input_ve_gp_pixel_movement
  end
  #--------------------------------------------------------------------------
  # * Alias method: move_by_input
  #--------------------------------------------------------------------------
  alias :update_vehicle_get_on_ve_gp_pixel_movement :update_vehicle_get_on
  def update_vehicle_get_on
    return unless @move_list.empty?
    @followers.gather   unless @followers.gathered?
    @through = false    if @followers.gathered?
    clear_next_movement if @followers.gathered?
    update_vehicle_get_on_ve_gp_pixel_movement if @followers.gathered?
  end
  #--------------------------------------------------------------------------
  # * Alias method: update_vehicle_get_off
  #--------------------------------------------------------------------------
  alias :update_vehicle_get_off_ve_gp_pixel_movement :update_vehicle_get_off
  def update_vehicle_get_off
    return unless @move_list.empty?
    @followers.gather   unless @followers.gathered?
    clear_next_movement if @followers.gathered?
    @through = false    if !@followers.gathering? && vehicle.altitude == 0
    update_vehicle_get_off_ve_gp_pixel_movement if @followers.gathered?
  end
  #--------------------------------------------------------------------------
  # * Alias method: get_off_vehicle
  #--------------------------------------------------------------------------
  alias :get_off_vehicle_ve_gp_pixel_movement :get_off_vehicle
  def get_off_vehicle
    result = get_off_vehicle_ve_gp_pixel_movement
    clear_vehicle_off if result
    result
  end
  #--------------------------------------------------------------------------
  # * New method: clear_vehicle_off
  #--------------------------------------------------------------------------
  def clear_vehicle_off
    @through = true
    clear_next_movement
    @followers.synchronize(@x, @y, @direction)
  end
  #--------------------------------------------------------------------------
  # * New method: check_event_contiontion
  #--------------------------------------------------------------------------
  def check_event_contiontion(x, y, event, triggers, normal)
    passable = passable_tile?(@x, @y, @direction)
    w = (counter_tile? || !passable) ? 1.0 : bw
    h = (counter_tile? || !passable) ? 1.0 : bh
    return false unless event.trigger_in?(triggers)
    return false unless event.event_priority?(normal)
    return false unless passable || event.over_tile? || counter_tile?
    return false unless event.collision?(x, y, w, h) || !jumping?
    return false unless !event.in_front? || front_collision?(x, y, @direction)
    return true
  end
  #--------------------------------------------------------------------------
  # * New method: counter_tile?
  #--------------------------------------------------------------------------
  def counter_tile?
    x = $game_map.check_x_with_direction(@x, @direction)
    y = $game_map.check_y_with_direction(@y, @direction)
    $game_map.counter?(x, y)
  end
  #--------------------------------------------------------------------------
  # * New method: setup_vehicle
  #--------------------------------------------------------------------------
  def setup_vehicle
    $game_map.vehicles.compact.each do |vehicle|
      next unless vehicle.enter_vechicle?(@x, @y, @direction)
      @vehicle_type = vehicle.type
      break if vehicle
    end
  end
  #--------------------------------------------------------------------------
  # * New method: enter_vehicle
  #--------------------------------------------------------------------------
  def enter_vehicle
    align_with(vehicle.x, vehicle.y) unless in_airship?
    @vehicle_getting_on = true
    force_move_forward unless in_airship?
    @through = true
    @followers.gather
  end
  #--------------------------------------------------------------------------
  # * New method: clear_next_movement
  #--------------------------------------------------------------------------
  def clear_next_movement
    @next_movement.clear
    @followers.clear_move_list
    @followers.clear_next_movement
  end
  #--------------------------------------------------------------------------
  # * New method: step_times
  #--------------------------------------------------------------------------
  def step_times
    (move_route_forcing || not_driving?) ? super : 1
  end
  #--------------------------------------------------------------------------
  # * New method: not_driving?
  #--------------------------------------------------------------------------
  def not_driving?
    vehicle && !vehicle.driving
  end
  #--------------------------------------------------------------------------
  # * New method: move_straight
  #--------------------------------------------------------------------------
  def move_straight(d, turn_ok = true)
    super
  end
  #--------------------------------------------------------------------------
  # * New method: move_diagonal
  #--------------------------------------------------------------------------
  def move_diagonal(horz, vert)
    super
  end
  #--------------------------------------------------------------------------
  # * New method: setup_bitmap_dimension
  #--------------------------------------------------------------------------
  def setup_bitmap_dimension
    s = ($game_player.battler.body.main_size / 65.0 * 4).round / 4
    @bw = @bh = s
#~     @bw = VE_PLAYER_BIG_COLLISION ? 1.0 : 0.75
#~     @bh = VE_PLAYER_BIG_COLLISION ? 1.0 : 0.75
  end
end

#==============================================================================
# ** Game_Follower
#------------------------------------------------------------------------------
#  This class handles the followers. Followers are the actors of the party
# that follows the leader in a line. It's used within the Game_Followers class.
#==============================================================================

class Game_Follower < Game_Character
  #--------------------------------------------------------------------------
  # * Overwrite method: chase_preceding_character
  #--------------------------------------------------------------------------
  def chase_preceding_character
    return if $imported[:ve_followers_control] && cant_follow_character
    return if $imported[:ve_followers_options]
    unless moving? || @move_list.size > 0
      move_size = @preceding_character.next_movement.size
      if move_size >= 8 || (move_size > 0 && gathering?)
        update_chasing
      elsif gathering? && !gathered?
        move_toward_player
        @move_list.clear if gathered?
      end
    end
  end
  #--------------------------------------------------------------------------
  # * New method: update_chasing
  #--------------------------------------------------------------------------
  def update_chasing
    next_move = @preceding_character.next_movement.shift
    move_straight(next_move)  if next_move.numeric?
    move_diagonal(*next_move) if next_move.array?
  end
  #--------------------------------------------------------------------------
  # * New method: gathered?
  #--------------------------------------------------------------------------
  def gathered?
    pos?($game_player.x, $game_player.y)
  end
  #--------------------------------------------------------------------------
  # * New method: move_straight
  #--------------------------------------------------------------------------
  def move_straight(d, turn_ok = true)
    super
  end
  #--------------------------------------------------------------------------
  # * New method: move_diagonal
  #--------------------------------------------------------------------------
  def move_diagonal(horz, vert)
    super
  end
  #--------------------------------------------------------------------------
  # * New method: movement_size
  #--------------------------------------------------------------------------
  def movement_size
    gathering? ? 0 : 8
  end
  #--------------------------------------------------------------------------
  # * New method: step_times
  #--------------------------------------------------------------------------
  def step_times
    move_route_forcing ? super : 1
  end
  #--------------------------------------------------------------------------
  # * New method: setup_bitmap_dimension
  #--------------------------------------------------------------------------
  def setup_bitmap_dimension
    @bw = VE_PLAYER_BIG_COLLISION ? 1.0 : 0.75
    @bh = VE_PLAYER_BIG_COLLISION ? 1.0 : 0.75
  end
end

#==============================================================================
# ** Game_Followers
#------------------------------------------------------------------------------
#  This class handles the followers. It's a wrapper for the built-in class
# "Array." It's used within the Game_Player class.
#==============================================================================

class Game_Followers
  #--------------------------------------------------------------------------
  # * New method: clear_next_movement
  #--------------------------------------------------------------------------
  def clear_next_movement
    each {|follower| follower.next_movement.clear }
  end
  #--------------------------------------------------------------------------
  # * New method: clear_move_list
  #--------------------------------------------------------------------------
  def clear_move_list
    each {|follower| follower.move_list.clear }
  end
  #--------------------------------------------------------------------------
  # * New method: gathered?
  #--------------------------------------------------------------------------
  def gathered?
    @data.all? {|follower| follower.gathered? }
  end
end

#==============================================================================
# ** Game_Event
#------------------------------------------------------------------------------
#  This class deals with events. It handles functions including event page 
# switching via condition determinants, and running parallel process events.
# It's used within the Game_Map class.
#==============================================================================

class Game_Event < Game_Character
  #--------------------------------------------------------------------------
  # * Overwrite method: collide_with_player_characters?
  #--------------------------------------------------------------------------
  def collide_with_player_characters?(x, y)
    normal_priority? && player_collision?(x, y) 
  end
  #--------------------------------------------------------------------------
  # * Alias method: start
  #--------------------------------------------------------------------------
  alias :start_ve_pixel_movement :start
  def start
    start_ve_pixel_movement
    $game_player.over_event = 8 if step_over? && !step_trigger?
  end
  #--------------------------------------------------------------------------
  # * Alias method: setup_page_settings
  #--------------------------------------------------------------------------
  alias :setup_page_settings_ve_pixel_movement :setup_page_settings
  def setup_page_settings
    setup_page_settings_ve_pixel_movement
    setup_size_dimension
    @move_steps   = note =~ /<MOVE STEPS: (\d+)>/i ? $1.to_i : nil
    @step_trigger = note =~ /<EACH STEP TRIGGER>/i ? true : false
    @in_front     = note =~ /<FRONT COLLISION>/i   ? true : false
    @over_tile    = note =~ /<OVER TILE>/i         ? true : false
    @side_fix     = note =~ /<NO SIDE COLLISION FIX>/i ? false : true
  end
  #--------------------------------------------------------------------------
  # * New method: player_collision?
  #--------------------------------------------------------------------------
  def player_collision?(x, y)
    $game_map.actors.any? {|actor| actor.collision?(x, y, bh, bw)}
  end  
  #--------------------------------------------------------------------------
  # * New method: event_priority?
  #--------------------------------------------------------------------------
  def event_priority?(normal)
    (normal_priority? == normal || (@through && !normal)) &&
    (normal_priority? || @trigger == 0 || $game_player.over_event == 0)
  end
  #--------------------------------------------------------------------------
  # * New method: check_event_trigger_touch
  #--------------------------------------------------------------------------
  def check_event_trigger_touch(x, y)
    return if $game_map.interpreter.running?
    if @trigger == 2 && $game_player.collision?(x, y, bh, bw)
      start if !jumping? && normal_priority?
    end
  end
  #--------------------------------------------------------------------------
  # * New method: step_over?
  #--------------------------------------------------------------------------
  def step_over?
    super || (@character_name == "" && @tile_id == 0) || @priority_type == 0
  end
  #--------------------------------------------------------------------------
  # * New method: step_times
  #--------------------------------------------------------------------------
  def step_times
    @move_steps ? @move_steps : super
  end
  #--------------------------------------------------------------------------
  # * New method: step_trigger?
  #--------------------------------------------------------------------------
  def step_trigger?
    @step_trigger
  end
  #--------------------------------------------------------------------------
  # * New method: in_front?
  #--------------------------------------------------------------------------
  def in_front?
    @in_front
  end
  #--------------------------------------------------------------------------
  # * New method: over_tile?
  #--------------------------------------------------------------------------
  def over_tile?
    @over_tile
  end
  #--------------------------------------------------------------------------
  # * New method: side_collision?
  #--------------------------------------------------------------------------
  def side_collision?
    @side_fix
  end
  #--------------------------------------------------------------------------
  # * New method: setup_bitmap_dimension
  #--------------------------------------------------------------------------
  def setup_bitmap_dimension
    setup_custom_dimension(get_collision_size,get_collision_size)
    regexp = /<EVENT SIZE: (\d+), (\d+)>/i
#~     note   =~ regexp ? setup_custom_dimension($1.to_i, $2.to_i) : super
  end
  #--------------------------------------------------------------------------
  # * New method: setup_custom_dimension
  #--------------------------------------------------------------------------
  def setup_custom_dimension(x, y)
    x1 = (x / 8).to_i
    y1 = (y / 8).to_i
    @bw = x1 / 4.0
    @bh = y1 / 4.0
  end
  
  
  def get_collision_size
    return self.battler.body.main_size / 65.0 * 32
  end
  
  def setup_size_dimension
    return
    puts 'meow'
    #return unless self.battler
    puts 'TAT'
    size = self.battler.body.main_size
    collision = size / 65.0 * 32
     x1 = (size / 8).to_i
    y1 = (size / 8).to_i
    
    @bw = x1 / 4.0
    @bh = y1 / 4.0
    
    @bw = @bg = 0.75
#~     puts @bw, @bh
  end
end

#==============================================================================
# ** Game_Vehicle
#------------------------------------------------------------------------------
#  This class handles vehicles. It's used within the Game_Map class. If there
# are no vehicles on the current map, the coordinates is set to (-1,-1).
#==============================================================================

class Game_Vehicle < Game_Character
  #--------------------------------------------------------------------------
  # * Overwrite method: land_ok?
  #--------------------------------------------------------------------------
  def land_ok?(x, y, d)
    @type == :airship ? airship_landable?(x, y) : check_landable?(x, y, d)
  end
  #--------------------------------------------------------------------------
  # * New method: land_test
  #--------------------------------------------------------------------------
  def land_test
    @land_test
  end
  #--------------------------------------------------------------------------
  # * New method: step_over?
  #--------------------------------------------------------------------------
  def step_over?
    above? || super
  end
  #--------------------------------------------------------------------------
  # * New method: check_landable?
  #--------------------------------------------------------------------------
  def check_landable?(x, y, d)
    x2 = $game_map.check_x_with_direction(x, d)
    y2 = $game_map.check_y_with_direction(y, d)
    @land_test = true
    result = passable?(x2, y2, d)
    @land_test = false
    result
  end
  #--------------------------------------------------------------------------
  # * New method: airship_landable?
  #--------------------------------------------------------------------------
  def airship_landable?(x, y)
    [2, 4, 6, 8].any? {|d| passable?(x, y, d) }
  end
  #--------------------------------------------------------------------------
  # * New method: passable_normal?
  #--------------------------------------------------------------------------
  def passable_normal?(x, y, d ,d2, ceil = false)
    @land_test ? landable_normal?(x, y, d ,d2, ceil) : super(x, y, d ,d2, ceil)
  end
  #--------------------------------------------------------------------------
  # * New method: landable_normal?
  #--------------------------------------------------------------------------
  def landable_normal?(x, y, d ,d2, ceil)
    x1 = $game_map.round_x(x)
    y1 = $game_map.round_y(y)
    return false unless $game_map.valid?(x1, y1)
    return true if @through || debug_through?
    return false unless map_passable?(x1, y1, d)
    return false unless map_passable?(x1, y1, d2) || !ceil
    return false unless map_passable?(x1, y1, reverse_dir(d))
    return true
  end
  #--------------------------------------------------------------------------
  # * New method: enter_vechicle?
  #--------------------------------------------------------------------------
  def enter_vechicle?(x, y, d)
    return false if @map_id != $game_map.map_id
    x2 = $game_map.round_x_with_direction(x, d)
    y2 = $game_map.round_y_with_direction(y, d)
    x3 = $game_map.check_x_with_direction(@x, reverse_dir(d))
    y3 = $game_map.check_y_with_direction(@y, reverse_dir(d))
    ( above? && collision?(x, y - 0.125, bw * 0.75, bh * 0.75)) ||
    (!above? && collision?(x2, y2, bw, bh) && map_passable?(x3, y3, d))
  end
  #--------------------------------------------------------------------------
  # * New method: collision_condition?
  #--------------------------------------------------------------------------
  def collision_condition?(x, y, bw, bh, player)
    return false if step_over? 
    return false if player.player? && self == player.vehicle
    return false if !collision?(x, y, bw, bh) 
    return true
  end
end