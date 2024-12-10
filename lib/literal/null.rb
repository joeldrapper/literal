# frozen_string_literal: true

module Literal::Null
	def self.inspect
		"Literal::Null"
	end

	def self.===(value)
		self == value
	end

	freeze
end
