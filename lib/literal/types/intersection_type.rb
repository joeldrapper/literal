# frozen_string_literal: true

# @api private
class Literal::Types::IntersectionType
	def initialize(*types)
		raise Literal::ArgumentError.new("_Intersection type must have at least one type.") if types.size < 1

		@types = types
	end

	attr_reader :types

	def inspect = "_Intersection(#{@types.map(&:inspect).join(', ')})"

	def ===(value)
		@types.all? { |type| type === value }
	end

	def nil?
		@types.all?(&:nil?)
	end

	def record_literal_type_errors(context)
		@types.each do |type|
			next if type === context.actual

			context.add_child(label: inspect, expected: type, actual: context.actual)
		end
	end
end
