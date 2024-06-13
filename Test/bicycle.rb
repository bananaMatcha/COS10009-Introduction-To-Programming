require './input_functions'

# Complete the code below
# Use input_functions to read the data from the user
class Bicycle
	attr_accessor :id, :model, :brand, :colour
	def initialize (id, model, brand, colour)
	@id = id 
	@model = model 
	@brand = brand 
	@colour = colour
	end
end

def read_bicycles()
	count = read_string("How many bicycles are you entering:")
	bicycles = Array.new()
  	index = 0
	while (index < count.to_i)
		bicycle = read_bicycle()
		bicycles << bicycle
		index += 1
	end
	return bicycles 
end

def read_bicycle()
	id = read_string("Enter bicycle id:")
	model = read_string("Enter bicycle model:")
	brand = read_string("Enter bicycle brand:")
	colour = read_string("Enter bicycle colour:")
	bicycle = Bicycle.new(id, model, brand, colour)
	return bicycle
end

def print_bicycles(bicycles)

	index = 0
	while (index < bicycles.length)
		puts("#{index}" )
		print_bicycle(bicycles[index])
		index += 1
	end
end

def print_bicycle(bicycle)
    
	puts("Bicycle id: " + bicycle.id )
	puts("Model: " + bicycle.model)
	puts("Brand: " + bicycle.brand)
	puts("Colour: " + bicycle.colour)
end

def main()

	bicycles = read_bicycles()
	
	print_bicycles(bicycles)
	
end

main()
