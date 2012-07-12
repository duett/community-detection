require "network"
require "simulated-annealing"

test = Network.new("email-Enron.txt")

test.nodes.each do |node|
	puts "#{node.id} : #{node.spin}"

end