class Node
	attr_accessor :id, :spin
	def initialize(id,spin)
		@id	  = id
		@spin = spin
	end
end

class Link
	attr_accessor :node1, :node2
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
		@groups 	= Array.new(q){[]}
		@q 			= q					## number of groups
		file = File.new(file_name, "r")
		@nodes << Node.new(0,rand(@q))
		while (line = file.gets)
			if line[0].chr!="#"
				a =  line.split("\t")
				if @nodes.size == 0 || @nodes[-1].id != a[0].to_i
					@nodes << Node.new(a[0].to_i,rand(@q))
				end
				@edges << Link.new( a[0].to_i, a[1].to_i)
			end
		end
		file.close
		@adjacency  = Array.new(@nodes.size){Array.new(@nodes.size){0}}
		@edges.each do |link| 
			@adjacency[link.node1][link.node2]=1
		end

		@nodes.each do |node|
			@groups[node.spin] << node.id
		end
		@nodes.uniq
		@edges.uniq
	end
	

end




