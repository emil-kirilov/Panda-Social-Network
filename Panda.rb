class Panda
	attr_reader :name, :email, :gender
	def initialize(name, email, gender)
		@name, @email, @gender = name, email, gender
	end

	def male?
		 return true if @gender == 'male'
		 false
	end

	def female?
		!male?
	end

	def hash
		email.hash
	end

	def to_s
		"Hello my name is #{name}. I am a healthy #{gender} individual so write to me on my email: #{email} "
	end

end

class PandaSocialNetwork
	attr_reader :panda_book

	def initialize
		@panda_book = {}
	end

	def add_panda(panda)
	if panda_book.has_key? panda
		raise "There's already such panda in the network"
	else
		panda_book[panda] 
	end
		# this method adds a panda to the social network. The panda has 0 friends for now. If the panda is already in the network, raise an PandaAlreadyThere error.
	end
	
	def has_panda(panda)
		- returns true or false if the panda is in the network or not.
	end
	
	def make_friends(panda1, panda2) -
		makes the two pandas friends. Raise PandasAlreadyFriends if they are already friends. The friendship is two-ways - panda1 is a friend with panda2 and panda2 is a friend with panda1. If panda1 or panda2 are not members of the network, add them!
	end
	
	def are_friends(panda1, panda2) 
		- returns true if the pandas are friends. Otherwise, false
	end

	def friends_of(panda)
		- returns a list of Panda with the friends of the given panda. Returns false if the panda is not a member of the network.
	end
	
	def connection_level(panda1, panda2) 
		- returns the connection level between panda1 and panda2. If they are friends, the level is 1. Otherwise, count the number of friends you need to go through from panda in order to get to panda2. If they are not connected at all, return -1! Return false if one of the pandas are not member of the network.
	end
	
	def are_connected(panda1, panda2) - return true if the pandas are connected somehow, between friends, or false otherwise.
		how_many_gender_in_network(level, panda, gender) - returns the number of gender pandas (male of female) that in the panda network in that many levels deep. If level == 2, we will have to look in all friends of panda and all of their friends too. And count
	end
end


ivo = Panda.new("Ivo", "ivo@pandamail.com", "male")
pivo = Panda.new("Ivo", "ivo@pandamail.com", "male")
p ivo.to_s
p ivo.hash
p pivo.hash
hash = {}
hash[ivo] = 124p213897529
hash[pivo] = 12385315