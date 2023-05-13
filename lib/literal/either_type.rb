# frozen_string_literal: true

class Literal::EitherType
	include Literal::Generic

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
			raise Literal::TypeError.expected(value, to_be_a: Literal::Types._Union(@left_type, @right_type))
		end
	end

	def left(value)
		case value
		when @left_type
			Literal::Left.new(value)
		else
			raise Literal::TypeError.expected(value, to_be_a: @left_type)
		end
	end

	def right(value)
		case value
		when @right_type
			Literal::Right.new(value)
		else
			raise Literal::TypeError.expected(value, to_be_a: @right_type)
		end
	end
end
