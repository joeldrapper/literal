class Literal::Types::NotType
	def initialize(type)
		@type = type
	end

	def inspect
		"_Not(#{@type.inspect})"
	end

	def ===(value)
		!(@type === value)
	end
end
