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

end

ivo = Panda.new("Ivo", "ivo@pandamail.com", "male")
puts ivo.female?