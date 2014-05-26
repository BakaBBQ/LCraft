class BackPack < Item
	def initialize
		super
		@shape = :backpack
	end
	
	def max_durability
		return 100
	end
	
	def used_out?
		return false
	end
	
	def what_it_is
		return "Backpack"
	end
	
	def size
		return 10.0
	end
	
	def max_size
		return (10 / hardness * toughness).abs.round(2)
	end
	alias container_size max_size
	
	def inspect
		return "<Backpack max_size:#{max_size} owner:#{owner.name} durability:#{durability}>"
	end
end