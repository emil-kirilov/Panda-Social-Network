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
		# this method adds a panda to the social network. The panda has 0 friends for now. If the panda is already in the network, raise an PandaAlreadyThere error.
		if panda_book.has_key? panda.email
			raise "There's already such panda in the network"
		else
			#trqbva da precenim kakvo da izpozlvame za kluch 
			panda_book[panda.email] = Array.new
		end

		panda_book
	end
	
	def has_panda(panda)
		#returns true or false if the panda is in the network or not.
		panda_found = false
		panda_found = true if panda_book.has_key? panda.email
		panda_found
	end
	
	def make_friends(panda1, panda2) 
		#makes the two pandas friends. Raise PandasAlreadyFriends if they are already friends. The friendship is two-ways - panda1 is a friend with panda2 and panda2 is a friend with panda1. If panda1 or panda2 are not members of the network, add them!
		raise 'PandasAlreadyFriends' if are_friends(panda1, panda2)
		panda_book[panda1.email] = Array.new unless panda_book.has_key? panda1.email			
		panda_book[panda2.email] = Array.new unless panda_book.has_key? panda2.email

		panda_book[panda1.email].push panda2
		panda_book[panda2.email].push panda1

		panda_book
	end
	
	def are_friends(panda1, panda2) 
		#- returns true if the pandas are friends. Otherwise, false
		are_friends = false
		are_friends = true if panda_book[panda1.email].include? panda2
		are_friends
	end

	def friends_of(panda)
		#- returns a list of Panda with the friends of the given panda. Returns false if the panda is not a member of the network.
		if panda_book.has_key? panda.email
			panda_book[panda.email]
		else
			return false 
		end
	end
	
	def connection_level(panda1, panda2) 
		#returns the connection level between panda1 and panda2. If they are friends, the level is 1. 
		#Otherwise, count the number of friends you need to go through from panda in order to get to panda2. 
		#If they are not connected at all, return -1! 
		#Return false if one of the pandas are not member of the network.
		return false unless panda_book.has_key? panda1.email or panda_book.has_key? panda2.email
		return 1 if are_friends(panda1, panda2)
		return -1 if  panda_book[panda1.email].length == 0 or panda_book[panda2.email].length == 0
		
		panda1_friends = panda_book[panda1.email]
		panda2_friends = panda_book[panda2.email]
		
		pandas_count = 0
		panda_book.each do |key, value|
			#this cycle will remove the pandas that have no friends from the counter
			pandas_count += 1 if value.length > 0
		end

		connection_level = 1
		continue = true
		last_check = false
		while continue
			connection_level += 1
			mutual_friends = panda1_friends & panda2_friends
			if mutual_friends.length > 0 
				return connection_level
			else
				return -1 if panda1_friends.length == pandas_count || panda2_friends.length == pandas_count
				return -1 if last_check
				temp_friends1 , temp_friends2 = [], []
				
				panda1_friends.each do |panda|
					temp_friends1 = temp_friends1 | panda_book[panda.email]
				end
				temp_friends1 += panda1_friends
				panda1_friends_at_max = true if temp_friends1.length == panda1_friends.length
				panda1_friends = temp_friends1

				panda2_friends.each do |panda|
					temp_friends2 = temp_friends2 | panda_book[panda.email]
				end
				temp_friends2 += panda2_friends
				panda2_friends_at_max = true if temp_friends2.length == panda2_friends.length
				panda2_friends = temp_friends2
				
				if panda1_friends_at_max and panda2_friends_at_max
					last_check = true
				end
			end
		end
	end
	
	def are_connected(panda1, panda2) 
		#- return true if the pandas are connected somehow, between friends, or false otherwise.
		if connection_level(panda1, panda2) != false and connection_level(panda1, panda2) != -1
			true
		else
			false
		end
	end
	
	def how_many_gender_in_network(level, panda, gender) 
		#returns the number of gender pandas (male of female) that in the panda network in that many levels deep.
		# If level == 2, we will have to look in all friends of panda and all of their friends too. And count
	end
end


ivo = Panda.new("Ivo", "ivo", "male")
pivo = Panda.new("pivo", "pivo", "male")
PSN = PandaSocialNetwork.new
p PSN.add_panda(ivo)
p PSN.add_panda(pivo)
p PSN.has_panda(ivo)
p PSN.has_panda(pivo)
jena1 = Panda.new("jena1", "jena1", "female")
jena2 = Panda.new("jena2", "jena2", "female")
PSN.make_friends(jena1, pivo)
PSN.make_friends(jena1, ivo)
PSN.make_friends(jena2, ivo)
p PSN.connection_level(jena2,pivo)
jena3 = Panda.new("jena3", "jena3", "female")
PSN.add_panda(jena3)
p PSN.connection_level(jena3,pivo)
p PSN.are_connected(jena3,pivo) 
p PSN.are_connected(jena2,pivo) 