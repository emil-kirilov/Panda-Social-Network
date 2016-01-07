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

	def to_s
		
	end

	def == (other)
		return true if name == other.name && email == other.email && gender == other.gender
		false
	end
end

ivo = Panda.new("Ivo", "ivo@pandamail.com", "male")
ivo2 = Panda.new("Ivo2", "ivo@pandamail.com", "male")
puts ivo == ivo2