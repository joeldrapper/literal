# frozen_string_literal: true

class Literal::Types::UnionType
	include Enumerable

	def initialize(*queue)
		raise Literal::ArgumentError.new("_Union type must have at least one type.") if queue.size < 1
		types = []
		primitives = Set[]

		while queue.length > 0
			type = queue.shift
			case type
			when Literal::Types::UnionType
				queue.concat(type.types, type.primitives.to_a)
			when Array, Hash, String, Symbol, Integer, Float, Complex, Rational, BigDecimal, true, false, nil
				primitives << type
			else
				types << type
			end
		end

		types.uniq!
		@types = types
		@primitives = primitives

		@types.freeze
		@primitives.freeze
		freeze
	end

	attr_reader :types, :primitives

	def inspect
		"_Union(#{@types.inspect})"
	end

	def ===(value)
		return true if @primitives.include?(value)

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

	freeze
end
