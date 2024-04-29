# frozen_string_literal: true

# @api private
Literal::Types::AnyType = Literal::Singleton.new do
	def initialize
		freeze
	end

	def inspect = "_Any"

	def ===(value)
		!(nil === value)
	end

	alias_method :==, :equal?
	alias_method :eql?, :==
end
