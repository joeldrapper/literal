# frozen_string_literal: true

# @api private
Literal::Types::VoidType = Literal::Singleton.new do
	def initialize
		freeze
	end

	def inspect = "_Void"

	def ===(_value)
		true
	end

	alias_method :==, :equal?
	alias_method :eql?, :==
end
