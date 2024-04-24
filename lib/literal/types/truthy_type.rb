# frozen_string_literal: true

# @api private
Literal::Types::TruthyType = Literal::Singleton.new do
	def initialize
		freeze
	end

	def inspect = "_Truthy"

	def ===(value)
		!!value
	end

	def ==(other)
		equal?(other)
	end
end
