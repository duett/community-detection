require "network"
require "simulated-annealing"

test = State.new("test_network.txt",2, 1)



simulated_annealing(test, distribution = method(:boltzmann), time_max = 300,  prob_restart = 0.000)


test.groups.each do |list|
	list.sort!
	puts list
	puts "++++"
end

