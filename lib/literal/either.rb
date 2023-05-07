# frozen_string_literal: true

class Literal::Either
	def initialize(left_type, right_type)
		@left_type = left_type
		@right_type = right_type
	end

	def inspect
		"Either(#{@left_type.inspect}, #{@right_type.inspect})"
	end

	def ===(either)
		case either
		when Literal::Left
			@left_type === either.value
		when Literal::Right
			@right_type === either.value
		else
			false
		end
	end

	def new(value)
		case value
		when @left_type
			Literal::Left.new(value)
		when @right_type
			Literal::Right.new(value)
		else
			raise Literal::TypeError,
				"Expected `#{value.inspect}` to be either `#{@left_type.inspect}` or `#{@right_type.inspect}`."
		end
	end
end
