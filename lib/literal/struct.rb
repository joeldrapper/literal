# frozen_string_literal: true

class Literal::Struct
	extend Literal::StructAttributes

	def self.attribute(name, type, special = nil, reader: :public, writer: :public, positional: false)
		super(name, type, special, reader:, writer:, positional:)
	end
end
