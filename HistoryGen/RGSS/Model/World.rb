class World
	# the world file, has all the information the world has, the basic model of the whole world
	ACCESSORS = [
		:name # the name of the world, on display
		
		:worldmap # the worldmap generated
		:chunks # a 200 * 200 * 30 Table, contains all the chunks
		
		[
			:rainmap,
			:forestmap,
			
		]
	]
	
	
	ACCESSORS.flatten.each do |a|
		attr_accessor	:a
	end
end