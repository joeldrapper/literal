# frozen_string_literal: true

# @abstract
class Literal::Either
	extend Literal::Modifiers

	def initialize(value)
		@value = value
		freeze
	end

	abstract!

	# @!method inspect
	# 	@return [String]
	abstract def inspect = nil

	# @!method left?
	# 	@return [Boolean]
	abstract def left? = nil

	# @!method right?
	# 	@return [Boolean]
	abstract def right? = nil

	# @!method left
	# 	@return [Literal::Either]
	abstract def left = nil

	# @!method right
	# 	@return [Literal::Either]
	abstract def right = nil

	attr_reader :value
	attr_accessor :type
end
