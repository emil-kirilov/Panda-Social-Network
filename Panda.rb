require 'json'
require 'yaml'
require 'xmlsimple'

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

	def ==(other)
		return true if email == other.email
		false
	end

	def eql?(other)
		return true if email == other.email
		false
	end

	def hash
		email.hash
	end

	def to_s
		"Hello my name is #{name}. I am a healthy #{gender} individual so write to me on my email: #{email} "
	end

	def to_a
		[].tap do |temp|
			temp << name
			temp << email
			temp << gender
		end
	end

	alias_method :eql?, :==
end

class PandaSocialNetwork
	attr_reader :panda_book, :hash_for_save

	def initialize
		@panda_book = {}
		@hash_for_save = {}
	end

	def add_panda(panda)
		# this method adds a panda to the social network. The panda has 0 friends for now. If the panda is already in the network, raise an PandaAlreadyThere error.
		if has_panda panda
			raise "There's already such panda in the network"
		else
			panda_book[panda.email] = []
			hash_for_save[panda.to_a] = []
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
		#makes the two pandas friends. Raise PandasAlreadyFriends if they are already friends. The friendship is two-ways - panda1 is a friend with panda2 and panda2 is a friend with panda1. 
		#If panda1 or panda2 are not members of the network, add them!
		raise 'PandasAlreadyFriends' if are_friends(panda1, panda2)

		panda_book[panda1.email] = [] if !has_panda panda1
		panda_book[panda2.email] = [] if !has_panda panda2
		panda_book[panda1.email] << panda2
		panda_book[panda2.email] << panda1

		hash_for_save[panda1.to_a] = [] if !hash_for_save.has_key? panda1.to_a			
		hash_for_save[panda2.to_a] = [] if !hash_for_save.has_key? panda2.to_a
		hash_for_save[panda1.to_a] << panda2.to_a
		hash_for_save[panda2.to_a] << panda1.to_a
		
		panda_book
	end
	
	def are_friends(panda1, panda2) 
		#- returns true if the pandas are friends. Otherwise, false
		are_friends = false
		panda_book[panda1.email] = [] if !has_panda panda1
		panda_book[panda2.email] = [] if !has_panda panda2
		
		are_friends = true if panda_book[panda1.email].include? panda2
		are_friends
	end

	def friends_of(panda)
		#- returns a list of Panda with the friends of the given panda. Returns false if the panda is not a member of the network.
		if !has_panda panda
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
		return false if !has_panda panda1 or !has_panda panda2
		return 1 if are_friends(panda1, panda2)
		return -1 if  panda_book[panda1.email].length == 0 or panda_book[panda2.email].length == 0
		
		q = Queue.new

		visited_pandas = []
		level = -1
		boolean = true
		last_panda_of_current_level = Panda.new('empty','shit','panda')
		q << (panda1)
		while !q.empty?
			if boolean
				last_panda_of_current_level = q.last
				level += 1
				boolean = false
			end
			current_panda = q.pop
			boolean = true if current_panda == last_panda_of_current_level
			visited_pandas << (current_panda)
			q << (panda_book[current_panda.email] - visited_pandas).flatten!
			visited_pandas << (panda_book[current_panda.email].flatten!)
			return level if visited_pandas.include? panda2
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

		friends = panda_book[panda.email]
		counter_gender = 0
		while level > 1
			friends.each do |friend|
				friends = friends | panda_book[friend.email]
			end	
			level -= 1
		end
		
		friends.delete(panda)
		friends.each do |friend|
			counter_gender +=1 if friend.gender == gender
		end

		counter_gender
	end

	def save(string)
	# valid parameters are: "json", "yaml", "xml", "emo"	
		case string
		when "json"
			json = Json.new
			json.save(hash_for_save)
		when "yaml"
			yaml = Yaml.new
			yaml.save(hash_for_save)
		when "xml"
			xml = Xml.new
			xml.save(hash_for_save)
		when "emo"
			emo = Emo.new
			emo.save(hash_for_save)
		else
			puts "Not a valid save format"
		end
	end

	def load(string)
	# valid parameters are: "json", "yaml", "xml", "emo"		
		case string
		when "json"
			json = Json.new
			json.load
		when "yaml"
			yaml = Yaml.new
			yaml.load
		when "xml"
			xml = Xml.new
			xml.load
		when "emo"
			emo = Emo.new
			emo.load
		else
			puts "Not a valid load format"
		end
	end
end

class Queue
	attr_accessor :queue
	def initialize
		@queue = []
	end

	def push(panda)
		queue << (panda)
	end

	def pop
		if empty?
			raise 'Queue is empty!'
		else
			queue.shift
		end
	end

	def empty?
		boolean = true
		boolean = false if queue.length > 0
		boolean
	end

	def last
		queue[queue.length - 1] if !empty?
	end
end

class Json
	def initialize
	end

	def save(hash_for_save)
		File.open("panda_save_json.json","w+") do |f|
  		f.write(hash_for_save.to_json)
		end
		hash_for_save
	end

	def load
		file = File.read("panda_save_json.json")
		panda_hash = JSON.parse(file)
		panda_hash
	end
end

class Emo
	def initialize
	end

	def save(hash_for_save)
		archive = File.new("panda_save.txt", "w+")
		
		hash_for_save.each_pair do |key, value|
			archive.puts "#{key} == #{value}"
		end

		archive.close
		archive
	end

	def load
		psn = PandaSocialNetwork.new

		archive = File.open("panda_save.txt")
		find = /\[(.*)\]\s\=\=\s\[(\[.*\])\]/
		find_name_email_gender = /\"(\w*)\"\,\s\"(\w*\@\w*\.\w*)\"\,\s\"(\w*)\"/
		find_each_friend = /\[(\"\w*\"\,\s\"\w*\@\w*\.\w*\"\,\s\"\w*\")\]\,?\s?/
		
		archive.each do |line|
			panda, friends_of_panda = find.match(line).captures

			name, email, gender = find_name_email_gender.match(panda).captures
			add_to_netwrok = Panda.new name, email, gender
			psn.add_panda(add_to_netwrok) unless psn.has_panda add_to_netwrok
				
			friends_of_panda.scan(find_each_friend) do |panda|
				name, email, gender = find_name_email_gender.match(panda[0]).captures
				make_friends_with_panda = Panda.new name, email, gender
				psn.make_friends(add_to_netwrok, make_friends_with_panda) unless psn.are_friends(add_to_netwrok, make_friends_with_panda)
			end
		end
		psn
	end 
end

class Yaml
	def save(hash_for_save)
		File.open("panda_save_yaml.yml", "w+") do |fyaml|
  		fyaml.write hash_for_save.to_yaml
		end
		hash_for_save
	end

	def load
		fyaml = YAML::load_file "panda_save_yaml.yml"
		panda_hash = fyaml.inspect
		panda_hash
	end
end

class Xml
	def save(hash_for_save)
		fxml = File.open("panda_save_xml.xml", "w+")
		fxml = XmlSimple.xml_in("panda_save_xml.xml", hash_for_save.to_xml)
		fxml
	end

	def load
	end
end

p = PandaSocialNetwork.new
ivo = Panda.new("Ivo", "ivo@pandamail.com", "male")
ivo1 = Panda.new("Ivo1", "ivo1@pandamail.com", "male")
ivo2 = Panda.new("Ivo2", "ivo2@pandamail.com", "male")
p.make_friends(ivo, ivo1)
p.make_friends(ivo, ivo2)
p.save("xml")
p.load("11yaml")