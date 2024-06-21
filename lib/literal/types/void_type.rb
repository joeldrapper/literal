# frozen_string_literal: true

# @api private
Literal::Types::VoidType = Literal::Singleton.new do
	def initialize
		freeze
	end

	def inspect = "_Void"

	def ===(_)
		true
	end
end
