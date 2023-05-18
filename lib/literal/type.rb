# frozen_string_literal: true

module Literal::Type
	extend Literal::Modifiers

	abstract!

	abstract def === = nil
	abstract def inspect = nil
end
