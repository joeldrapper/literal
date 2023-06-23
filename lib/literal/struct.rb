# frozen_string_literal: true

class Literal::Struct
	extend Literal::StructAttributes

	def self.attribute(name, type, special = nil, reader: :public, writer: :public, positional: false, default: nil)
		super(name, type, special, reader:, writer:, positional:, default:)
	end

	def self.from_pack(payload)
		allocate.tap do |object|
			object.instance_eval do
				@attributes = payload[:attributes]
				@literal_attributes = payload[:literal_attributes]
				freeze if payload[:frozen?]
			end
		end
	end

	def as_pack
		{
			frozen?: frozen?,
			attributes: @attributes,
			literal_attributes: @literal_attributes
		}
	end
end
