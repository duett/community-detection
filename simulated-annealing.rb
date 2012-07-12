require "network"


# Initial values
TEST		=true
PROB_RESTART=0.001
TIME_MAX	= 3000
MAX_ENERGY	= 0
ALPHA		= 0.95


class State < Network
	attr_accessor :energy 
	# energy calculates engery of state
	# neighbor gives random neighboring state (i.e. 1 spin turned)
	def initialize(file_name, q)
		super(file_name,q)
	end
	# in the Potts-model of Reichard/Bornholdt the adhesion is needed 
	# to calculate the energy difference (for def see paper in README.md)
	# case used: every links is equally probable p
	def adhesion(r,s,p,gamma)
		m_rs = 0
		m_rs_av = gamma*p*@groups[r].size*@groups[s].size
		@groups[r].each do |node_i| 
			@groups[s].each do |node_j|
				if @adjacency[node_i][node_j] == 1
					m_rs +=1
				end
			end
		end
		return m_rs - m_rs_av
	end


end

def neighbor_state(state)
	out = state 
	pick_id 	= rand(out.nodes.size)
	begin 
		new_spin	= rand(out.q)
	end while out.nodes[pick_id].spin == new_spin
	out.nodes[pick_id].spin = new_spin

	##HERE ENERGY UPDATE
	return out
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
	current	= initial
	best	= current
	while  t < time_max && current.energy > max_energy
		current = if rand < prob_restart
			t_after_restart = 0
			current.lottery()
		else
			new_state  = current.neighbor_state()
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
