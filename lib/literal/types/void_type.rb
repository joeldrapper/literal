# frozen_string_literal: true

# @api private
class Literal::Types::VoidTypeClass
	include Literal::Type

	def inspect
		"_Void"
	end

	def ===(_)
		true
	end

	def >=(_)
		true
	end

	freeze
end

Literal::Types::VoidType = Literal::Types::VoidTypeClass.new.freeze
