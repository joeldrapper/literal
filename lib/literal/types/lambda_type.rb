# frozen_string_literal: true

# @api private
Literal::Types::LambdaType = Literal::Singleton.new do
	def initialize
		freeze
	end

	def inspect = "_Lambda"

	def ===(value)
		Proc === value && value.lambda?
	end

	alias_method :==, :equal?
	alias_method :eql?, :==
end
