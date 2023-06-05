# frozen_string_literal: true

class Literal::Type
	extend Literal::Modifiers

	abstract!

	abstract def === = nil
	abstract def inspect = nil
end
