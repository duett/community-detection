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
					@nodes << a[0]
				end
				@edges << a
			end
		end
		file.close
	end
	 
end

test = Network.new("email-Enron.txt")

puts test.nodes