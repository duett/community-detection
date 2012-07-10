class Network
	attr_accessor :n_nodes, :n_edges, :nodes, :edges

	def initialize(nodes, edges)
		@nodes = Vector.new
		@edges = edges
	end

end


counter = 1
file = File.new("email_Enron.txt", "r")
while (line = file.gets)
	arr = line.split("\t")
    puts "#{counter}:  #{arr[0]} --  #{arr[1]}  "
    counter = counter + 1
 end
 file.close