# frozen_string_literal: true

class Literal::Types::PatternType < Literal::Type
	def initialize(*array_pattern)
		@array_pattern = array_pattern
	end

	def inspect = "_Pattern(#{@array_pattern.inspect})"

	def ===(value)
		Array === value && matches(value)
	end

	private def matches(value)
		i = 0
		@array_pattern.each do |type|
			case type
			when Literal::Types::OptionalType
				i += 1 if type === value[i]
			when Literal::Types::RestType
				i += 1 while type === value[i]
			else
				if type === value[i]
					i += 1
				else
					return false
				end
			end
		end

		i == value.size
	end
end
