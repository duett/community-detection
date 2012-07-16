require "Network"


# Initial values
TEST		=true
PROB_RESTART=0
TIME_MAX	= 30000
MAX_ENERGY	= -100000
ALPHA		= 0.95
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
			@energy -= (@adjacency[link.node1][link.node2]-@gamma*@p) 
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
		a_l_phi = @groups[old_spin].inject{|result, element| result + @adjacency[rand_id][element]}
		a_l_phi = a_l_phi - @gamma*@p*(@groups[old_spin].size-1)
		a_l_alpha = 0
		@groups[new_spin].each do |i| 
			a_l_alpha += @adjacency[rand_id][i]
		end
		a_l_alpha -= @gamma*@p*(@groups[new_spin].size)

		@energy += a_l_phi - a_l_alpha
		@groups[old_spin].drop(rand_id)
		@groups[new_spin] << rand_id
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
		temp			= temp(ALPHA),
		distribution 	= method(:boltzmann))
		
	t  				= 0
	t_after_restart = 0
	current			= initial
	best			= current

	while  t < time_max && current.energy > max_energy
		current = if rand < prob_restart
			t_after_restart = 0
			current.lottery()
		else
			new_state  = current
			new_state.neighbor_state()
			puts "|||||\n"
			puts distribution.call(current.energy, new_state.energy, temp)
		end
		if distribution.call(current.energy, new_state.energy, temp) > rand
			current = new_state
		end
		if current.energy < best.energy
			best = current
		end
		t += 1
	end
end
