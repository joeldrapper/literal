# frozen_string_literal: true

# @api private
class Literal::Type
	extend Literal::Modifiers

	abstract!

	abstract def ===(value) = nil
	abstract def inspect = nil
end
