# frozen_string_literal: true

class Literal::Variant
	def initialize(value, *types)
		unless types.any? { |type| type === value }
			raise Literal::TypeError
		end

		@value = value
		@types = types
	end

	def union
		Literal::Types::UnionType.new(*@types)
	end

	def handle(&)
		Literal::Switch.new(*@types, &).call(@value, @value)
	end

	alias_method :call, :handle

	def to_proc
		method(:call).to_proc
	end
end
