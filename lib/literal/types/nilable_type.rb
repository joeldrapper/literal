# frozen_string_literal: true

# @api private
class Literal::Types::NilableType
	def initialize(type)
		@type = type
	end

	def inspect = "_Nilable(#{@type.inspect})"

	def ===(value)
		nil === value || @type === value
	end

	def record_literal_type_errors(ctx)
		@type.record_literal_type_errors(ctx) if @type.respond_to?(:record_literal_type_errors)
	end

	freeze
end
