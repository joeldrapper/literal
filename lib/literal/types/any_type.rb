# frozen_string_literal: true

Literal::Types::AnyType = Literal::Singleton.new do
	include Literal::Type

	def initialize
		freeze
	end

	def inspect = "_Any"

	def ===(value)
		!value.nil?
	end
end
