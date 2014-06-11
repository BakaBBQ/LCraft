=begin

Goal - The Ultimate Motivation for Everything

Goal includes 2 concepts
 - protect
 - attack

 
  - protect : [:own_kind, :everyone, :none]
  - attack : [:not_my_kind, :intruder, :no_one]
 
 a normal enemy will want to attack everything except their own kind
=end
Game_Battler = Class.new Game_Battler.clone do
  attr_accessor :goal
  attr_accessor :party
end
