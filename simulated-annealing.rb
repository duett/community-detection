require "Network"


# Initial values
TEST		=true
PROB_RESTART=0.001
TIME_MAX	= 3000
MAX_ENERGY	= 0
ALPHA		= 0.95
GAMMA 		= 1
NULL_P 		= 0.01

class State < Network
	attr_accessor :energy, :p, :gamma
	# energy calculates engery of state
	# neighbor gives random neighboring state (i.e. 1 spin turned)
	def initialize(file_name, q, gamma,p)
		super(file_name,q)
		@p = p
		@gamma = gamma
		@energy = 0
		@edges.each do |link|
			@energy -= (@adjacency[link.node1][link.node2]-@gamma*@p) 
		end
	end


	def neighbor_state()
		old_spin = @nodes[pick_id].spin
		begin 
			new_spin	= rand(@q)
		end while @nodes[pick_id].spin == new_spin
		@nodes[pick_id].spin = new_spin
		## energy update
		## calculate adhesions: null model = links established with equal probability p
		a_l_phi = @groups[old_spin].inject{|result, element| result + @adjacency[pick_id][element]}
		a_l_phi = a_l_phi - @gamma*@p*(@group[old_spin]-1)
		a_l_alpha = @groups[new_spin].inject([]) do |result, element|
  			result + @adjacency[pick_id][element]
  			result
		end
		a_l_alpha = a_l_alpha - @gamma*@p*(@group[new_spin])

		@energy = @energy + a_l_phi - a_l_alpha
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
		temp			= temp(alpha),
		distribution   	= method(:boltzmann))
	
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
			new_state  = new_state.neighbor_state()
		end
		if distribution(current.energy,new_state.energy,temp) > rand
			current = new_state
		end
		if current.energy < best.energy
			best = current
		end
		t += 1
	end
end
