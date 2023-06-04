# frozen_string_literal: true

class Foo
	extend Literal::Attributes

	def initialize(foo:)
		super(foo:)
		@bar = 1
	end

	attribute :foo, Integer
end
