# frozen_string_literal: true

module Literal::Schema
	def __schema__
		return @__schema__ if defined?(@__schema__)

		@__schema__ = superclass.is_a?(self) ? superclass.__schema__.dup : {}
	end
end
