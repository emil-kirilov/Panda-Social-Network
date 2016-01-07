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

	def ==(other)
		return true if email == other.email
		false
	end

	def hash
		email.hash
	end
end
