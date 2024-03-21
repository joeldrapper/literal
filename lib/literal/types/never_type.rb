# frozen_string_literal: true

# @api private
Literal::Types::NeverType = Literal::Singleton.new do
	def initialize
		freeze
	end

	def inspect = "_Never"

	def ===(value)
		false
	end
end
