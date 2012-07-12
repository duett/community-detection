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
	attr_accessor :nodes, :edges, :neighbors, :groups, :q, :adjacency
	def initialize(file_name, q)
		@nodes 		= []
		@edges 		= []
		@neighbors 	= []
		@groups 	= Array.new(q){[]}
		@q 			= q
		file = File.new(file_name, "r")
		while (line = file.gets)
			if line[0].chr!="#"
				a =  line.split("\t")
				if @nodes[-1]!= a[0]
					@nodes << Node.new(a[0].to_i,rand(@q))
				end
				@edges << Link.new(a[0].to_i,a[1].to_i)
				@neighbors[a[1].to_i] = []
			end
		end
		file.close
		@adjacency  = Array.new(@nodes.size){Array.new(@nodes.size){0}}
		@edges.each do |link| 
			@neighbors[link.node2] << link.node1
			@adjacency[link.node1][link.node2]=1
		end
		@nodes.each do |node|
			@groups[node.spin] << node.id
		end

	end
	def self.lottery()
		@groups 	= Array.new(){[]}
		@nodes.each do |node| 
			node.spin = rand(@q)
			@groups[node.spin] << node.id
		end

	end

end




