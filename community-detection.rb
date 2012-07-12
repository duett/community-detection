require "network"
require "simulated-annealing"

test = Network.new("email-Enron.txt",70000)

#test.nodes.each do |node|
	#puts "#{node.id} : #{node.spin} : "
#end
	puts test.groups[1]
