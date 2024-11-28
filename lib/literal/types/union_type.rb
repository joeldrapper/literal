# frozen_string_literal: true

class Literal::Types::UnionType
	include Enumerable

	def initialize(*types)
		raise Literal::ArgumentError.new("_Union type must have at least one type.") if types.size < 1

		@types = []
		load_types(types)
		@types.uniq!
		@types.freeze
	end

	attr_reader :types

	def inspect
		"_Union(#{@types.inspect})"
	end

	def ===(value)
		types = @types
		i, len = 0, types.size
		while i < len
			return true if types[i] === value
			i += 1
		end
	end

	def each(&)
		@types.each(&)
	end

	def deconstruct
		@types.to_a
	end

	def [](key)
		if @types.include?(key)
			key
		else
			raise ArgumentError.new("#{key} not in #{inspect}")
		end
	end

	def record_literal_type_errors(ctx)
		@types.each do |type|
			ctx.add_child(label: type.inspect, expected: type, actual: ctx.actual)
		end
		ctx.children.clear if ctx.children.none? { |c| c.children.any? }
	end

	def >=(other)
		case other
		when Literal::Types::UnionType
			other.types.all? do |other_type|
				@types.any? do |type|
					Literal.subtype?(type, of: other_type)
				end
			end
		else
			@types.any? do |type|
				Literal.subtype?(other, of: type)
			end
		end
	end

	private

	def load_types(types)
		types.each do |type|
			(Literal::Types::UnionType === type) ? load_types(type.types) : @types << type
		end
	end
end
