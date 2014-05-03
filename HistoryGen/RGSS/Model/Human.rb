class Human
	# the world file, has all the information the world has, the basic model of the whole world
	ACCESSORS = [
		:name, # the name who people just call
		:family_name, # the family name
		
		:father, # male parent
		:mother, # female parent
	]
	
	
	ACCESSORS.flatten.each do |a|
		attr_accessor	:a
	end
end