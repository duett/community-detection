require "network"


# Initial values
TEST		=true
PROB_RESTART=0
TIME_MAX	= 300000
MAX_ENERGY	= -100000
ALPHA		= 0.999
GAMMA 		= 1
NULL_P 		= 0.1

class State < Network
	attr_accessor :energy, :p, :gamma
	# energy calculates engery of state
	# neighbor gives random neighboring state (i.e. 1 spin turned)
	def initialize(file_name, q, gamma)
		super(file_name,q)
		@p = @edges.size/@nodes.size
		@gamma = gamma
		@energy = 0
		@edges.each do |link|
			if  link.node1 < link.node2 && @nodes[link.node1].spin == @nodes[link.node2].spin 
				@energy -= 2*(@adjacency[link.node1][link.node2]-@gamma*@p) 
			end
		end

	end
	def neighbor_energy_diff
		rand_id = rand(@nodes.size)
		old_spin = @nodes[rand_id].spin
		begin 
			new_spin	= rand(@q)
		end while @nodes[rand_id].spin == new_spin
		dE = 0
		@groups[old_spin].each do |member|
			if @adjacency[member][rand_id] == 1 && member != rand_id
				dE+=1
			end
		end
		dE-= @gamma*@p*(@groups[old_spin].size - 1)

		@groups[new_spin].each do |member|
			if @adjacency[member][rand_id] == 1 && member != rand_id
				dE+=1
			end
		end
		dE+= @gamma*@p*@groups[new_spin].size 
		Hash["rand_id",rand_id,"new_spin", new_spin, "dE", dE]
	end

	def neighbor_state(rand_id,new_spin,dE)
		@energy += dE
		old_spin = @nodes[rand_id].spin
		@nodes[rand_id].spin = new_spin
		@groups[old_spin].delete(rand_id)
		@groups[new_spin] << rand_id


	end
	
	def lottery
		@groups 	= Array.new(q){[]}
		@nodes.each do |node| 
			node.spin =rand(@q)
			@groups[node.spin] << node.id
		end
		@energy = 0
		@edges.each do |link|
			if  link.node1 < link.node2 && @nodes[link.node1].spin == @nodes[link.node2].spin 
				@energy -= 2*(@adjacency[link.node1][link.node2]-@gamma*@p) 
			end
		end


	end

end








# assumption: exponential cooling schedule
def temp(alpha)
	lambda{|time| alpha**time}
end

# assumption: boltzmann-distribution
def boltzmann(dE, temp)
  return  dE < 0 ? 1 :   -Math.exp(dE *(1-temp))
end

def simulated_annealing( initial,
		prob_restart 	= PROB_RESTART,
		time_max		= TIME_MAX,
		max_energy 		= MAX_ENERGY,
		temperature		= temp(ALPHA),
		distribution 	= method(:boltzmann))

	t  				= 0
	t_after_restart = 0
	current			= initial
	best			= current.clone
	
	while  t < time_max

		update = current.neighbor_energy_diff
#		puts " #{update['rand_id']} : #{update['new_spin']} : #{update['dE']}"
		tmp = temperature.call(t)
		if distribution.call(update["dE"], tmp) > rand
			current.neighbor_state(update["rand_id"],update["new_spin"],update["dE"])
			puts update["dE"]
		end
		if current.energy < best.energy
			best = Marshal::load(Marshal.dump(current))
		end

		t += 1
		t_after_restart += 1
		if TEST 
		#	puts current.energy
		end
	end
	current
end



