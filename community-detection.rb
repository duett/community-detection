require "network"
require "simulated-annealing"

test = State.new("test_network.txt",4, 1, 0.1 )

simulated_annealing(
 		test,
		PROB_RESTART,
		TIME_MAX,
		MAX_ENERGY,
		temp(ALPHA),
		method(:boltzmann)
)

#test.nodes.each do |node|
	#puts "#{node.id} : #{node.spin} : "
#end
	puts test.groups[1]
	puts "---"
	puts test.groups[2]
	puts "---"
	puts test.groups[3]
	puts "---"
	puts test.groups[4]

