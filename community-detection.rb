class Node
	attr_accessor :id, :spin
	def initialize(id,spin)
		@id	  = id
		@spin = spin
	end
end

class Link
	attr_accessor :id, :node1, :node2
	def initialize(node1,node2)
		@node1 = node1
		@node2 = node2
	end
end


class Network
	attr_accessor :nodes, :edges
	 
	def initialize(file_name)
		@nodes = []
		@edges = []
		file = File.new(file_name, "r")
		while (line = file.gets)
			if line[0].chr!="#"
				a =  line.split("\t")
				if @nodes[-1]!= a[0]
					@nodes << Node.new(a[0],0)
				end
				@edges << Link.new(a[0],a[1])
			end
		end
		file.close
	end
	 
end

test = Network.new("email-Enron.txt")

test.nodes.each do |node|
	puts "#{node.id} : #{node.spin}"

end