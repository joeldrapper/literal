# frozen_string_literal: true

module Literal::Types::AnyType
	def self.===(value)
		!value.nil?
	end
end
