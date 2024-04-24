# frozen_string_literal: true

# @api private
Literal::Types::BooleanType = Literal::Singleton.new do
	def initialize
		freeze
	end

	def inspect = "_Boolean"

	def ===(value)
		true == value || false == value
	end

	alias_method :==, :equal?
	alias_method :eql?, :==
end
