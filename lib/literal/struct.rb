# frozen_string_literal: true

class Literal::Struct
	extend Literal::StructAttributes

	def self.attribute(name, type, special = nil, reader: true, writer: true, positional: false)
		super(name, type, special, reader:, writer:, positional:)
	end
end
