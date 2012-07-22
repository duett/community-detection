require "network"
require "simulated-annealing"

DEBUGGER = true


test = State.new("test_network.txt",2, 1)




if DEBUGGER
	puts "A"
	test.groups.each do |list|
		list.sort!
		puts "++++"

		puts list
	end
	puts "++++"
	puts "ENERGY: #{test.energy}"
	puts " "
	
	test = simulated_annealing(test, distribution 	= method(:boltzmann), time_max = 30000)
	puts " "
	puts "B"
	test.groups.each do |list|
		list.sort!
		puts "++++"

		puts list
	end
	puts "++++"
	puts "ENERGY: #{test.energy}"


end

