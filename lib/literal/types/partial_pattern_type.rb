# frozen_string_literal: true

class Literal::Types::PartialPatternType < Literal::Type
	def initialize(*pattern)
		@pattern = pattern
	end

	def inspect = "_PartialPattern(#{@pattern.inspect})"

	def ===(value)
		Array === value && matches(value)
	end

	private def matches(value)
		i = 0
		size = value.size

		@pattern.each do |type|
			case type
			when Literal::Types::OptionalType
				i += 1 if type === value[i]
			when Literal::Types::RestType
				i += 1 while type === value[i] && i < size
			else
				if type === value[i]
					i += 1
				else
					return false
				end
			end
		end

		true
	end
end
