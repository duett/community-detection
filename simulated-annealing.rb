require "Network"


# Initial values
TEST		=true
PROB_RESTART=0
TIME_MAX	= 300000
MAX_ENERGY	= -100000
ALPHA		= 0.99
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
		@groups.each do |list|
			
		end
		
		@edges.each do |link|
			if  link.node1 < link.node2 && @nodes[link.node1].spin == @nodes[link.node2].spin 
				@energy -= 2*(@adjacency[link.node1][link.node2]-@gamma*@p) 
			end
		end

	end
	def neighbor_state()
		rand_id = rand(@nodes.size)
		old_spin = @nodes[rand_id].spin
		begin 
			new_spin	= rand(@q)
		end while @nodes[rand_id].spin == new_spin
		@nodes[rand_id].spin = new_spin

		## energy update
		## calculate adhesions: null model = links established with equal probability p
	#	a_l_phi = @groups[old_spin].inject{|result, element| result + @adjacency[rand_id][element]}
	#	a_l_phi = a_l_phi - @gamma*@p*(@groups[old_spin].size-1)
	#	a_l_alpha = 0
	#	@groups[new_spin].each do |i| 
	#		a_l_alpha += @adjacency[rand_id][i]
	#	end
	#	a_l_alpha -= @gamma*@p*(@groups[new_spin].size)

		#@energy += a_l_phi - a_l_alpha
	#	@groups[old_spin].each do |members| 
	#		@neighbors[members].delete(rand_id)
	#	end
	#	@groups[new_spin].each do |members| 
	#		@neighbors[members] << rand_id
	#	end
		@groups[old_spin].delete(rand_id)
		@groups[new_spin] << rand_id
		@energy = 0
		@edges.each do |link|
			if  link.node1 < link.node2 && @nodes[link.node1].spin == @nodes[link.node2].spin 
				@energy -= 2*(@adjacency[link.node1][link.node2]-@gamma*@p) 
			end
		end


	end
	
	def lottery()
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
def boltzmann(e, e_new, temp)
  return 1 if e_new > e
  Math.exp((e_new-e) * (1.0 - temp))
  
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

	best			= current
	while  t < time_max
		new_state  = current.clone
		new_state.neighbor_state()
		tmp = temperature.call(t)
		if distribution.call(current.energy, new_state.energy, tmp) > rand
			current = new_state.clone
		end
		if current.energy < best.energy
			best = current.clone
		end

		t += 1
	end
end


