# frozen_string_literal: true

module Literal::Singleton
	def self.new(...)
		Class.new(...).new
	end
end
