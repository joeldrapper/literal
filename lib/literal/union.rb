# frozen_string_literal: true

class Literal::Union
	include Enumerable

	def initialize(*types)
		@types = types
	end

	def inspect = "Literal::Union(#{@types.map(&:inspect).join(', ')})"

	def ===(value)
		@types.any? { |type| type === value }
	end

	def each(&)
		@types.each(&)
	end

	def [](key)
		index.fetch(key)
	end

	def index
		@index ||= @types.index_by(&:itself)
	end

	def handle(value, &)
		Literal::Variant.new(value, *@types).handle(&)
	end

	def variant(value = Literal::Null)
		if Literal::Null != value
			Literal::Variant.new(value, *@types)
		elsif block_given?
			Literal::Variant.new(yield, *@types)
		else
			Literal::VariantType.new(*@types)
		end
	end

	def deconstruct
		@types
	end

	def deconstruct_keys(_)
		{ types: @types }
	end
end
