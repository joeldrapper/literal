# frozen_string_literal: true

class Literal::Struct < Literal::StructLike
	class << self
		def attribute(name, type, special = nil, reader: :public, writer: :public, positional: false, default: nil)
			super(name, type, special, reader:, writer:, positional:, default:)
		end
	end

	def marshal_load(data)
		@attributes = data[:attributes]
		@literal_attributes = self.class.literal_attributes
		freeze if data[:frozen?]
	end

	def marshal_dump
		{
			v: 1,
			frozen?: frozen?,
			attributes: @attributes
		}
	end
end
