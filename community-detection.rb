require "network"
require "simulated-annealing"

test = State.new("test_network.txt",3, 1)
#puts test.energy


test.neighbor_state()
#puts test.energy

#puts test.energy
simulated_annealing(test)


#test.nodes.each do |node|
	#puts "#{node.id} : #{node.spin} : "
#end
#	puts "---"
#	puts test.groups[0]
#	puts "---"
#	puts test.groups[1]
#	puts "---"
#	puts test.groups[2]
#	puts "---"
#	puts test.groups[3]
