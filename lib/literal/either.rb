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
	abstract :inspect

	# @!method left?
	# 	@return [Boolean]
	abstract :left?

	# @!method right?
	# 	@return [Boolean]
	abstract :right?

	# @!method left
	# 	@return [Literal::Either]
	abstract :left

	# @!method right
	# 	@return [Literal::Either]
	abstract :right

	attr_reader :value
	attr_accessor :type
end
