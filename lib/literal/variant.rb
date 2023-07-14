# frozen_string_literal: true

class Literal::Variant
	def initialize(value, *types)
		unless types.any? { |type| type === value }
			raise Literal::TypeError
		end

		@value = value
		@types = types
	end

	def self.rescue(...)
		Literal::VariantType.new.rescue(...)
	end

	attr_reader :value

	def deconstruct
		[value]
	end

	def deconstruct_keys(_)
		{ value: @value }
	end

	def union
		Literal::Types::UnionType.new(*@types)
	end

	def handle(&block)
		if block
			Literal::Switch.new(*@types, &block).call(@value)
		else
			self
		end
	end

	alias_method :call, :handle

	def to_proc
		method(:call).to_proc
	end

	def maybe(type)
		if type === @value
			Literal::Some.new(@value)
		else
			Literal::Nothing
		end
	end
end
