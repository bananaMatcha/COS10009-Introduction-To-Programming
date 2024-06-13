require './input_functions'

# Complete the code below
# Use input_functions to read the data from the user

# define a Computer below:

class Computer
	attr_accessor :id, :manufacturer, :model, :price
	def initialize (id, manufacturer, model, price)
		@id =id
		@manufacturer = manufacturer
		@model = model
		@price = price
	end
end


def read_a_computer()
	# put more code here
	id = read_integer('Enter computer id:').to_s
	manufacturer = read_string('Enter manufacturer:')
	model = read_string('Enter model:')
	price = read_float('Enter price:') 

	computer = Computer.new(id, manufacturer, model, price)
	return computer
end

def read_computers()
	count =read_integer('How many computers are you entering:')
	computers = Array.new()
	index = 0
	while (index < count)
		computer= read_a_computer()
		computers << computer
		index +=1
	end
	return computers
end

def print_a_computer(computer)
	puts ('Id: ' + computer.id)
	puts ('Manufacturer: ' + computer.manufacturer)
	puts ('Model: ' + computer.model)
	printf("Price: %.2f\n", computer.price)
end

def print_computers(computers)
	index = 0
	while (index < computers.length)
		print_a_computer(computers[index])
		index +=1
	end
end

def main()
	computers = read_computers()
	print_computers(computers)
end

main()