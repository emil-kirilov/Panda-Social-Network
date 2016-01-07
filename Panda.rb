class Panda
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

	def = (other)
		return true if self.name == other.name && 
		   			  self.email == other.email &&
		   			  self.gender == other.gender
		false
	end
end

