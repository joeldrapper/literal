# frozen_string_literal: true

class Literal::Struct
	extend Literal::StructAttributes

	def self.attribute(name, type, special = nil, reader: :public, writer: :public, positional: false, default: nil)
		super(name, type, special, reader:, writer:, positional:, default:)
	end

	def self.from_pack(payload)
		allocate.tap do |object|
			object.instance_variable_set(:@attributes, payload[:attributes])
			object.freeze if payload[:frozen]
		end
	end

	def as_pack
		{
			frozen: frozen?,
			attributes: @attributes
		}
	end
end
