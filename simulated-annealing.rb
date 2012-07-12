require "network"


# Initial values
TEST		=true
PROB_RESTART=0.001
TIME_MAX	= 3000
ENERGY_MAX	= 0
ALPHA		= 0.95


class State < Network
	attr_accessor :energy, :neighbor_state
	# energy calculates engery of state
	# neighbor gives random neighboring state (i.e. 1 spin turned)


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


def simulated_annealing




end
