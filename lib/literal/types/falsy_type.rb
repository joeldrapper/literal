# frozen_string_literal: true

# @api private
Literal::Types::FalsyType = Literal::Singleton.new do
	def initialize
		freeze
	end

	def inspect = "_Falsy"

	def ===(value)
		!value
	end
	
	def ==(other)
		equal?(other)
	end
end
