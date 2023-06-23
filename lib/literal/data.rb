# frozen_string_literal: true

class Literal::Data
	extend Literal::StructAttributes

	def self.attribute(name, type, special = nil, reader: :public, positional: false, default: nil)
		super(name, type, special, reader:, writer: false, positional:, default:)
	end

	def self.literal_initializer_body = "#{super}; freeze"

	def self.from_pack(payload)
		allocate.tap do |object|
			object.instance_variable_set(:@attributes, payload[:attributes])
			object.freeze
		end
	end

	def as_pack
		{
			attributes: @attributes
		}
	end

	def with(**new_attributes)
		new_attributes.each do |name, value|
			if Literal::TYPE_CHECKS
				unless (type = @literal_attributes[name].type)
					raise Literal::ArgumentError, "Unknown attribute `#{name.inspect}`."
				end

				unless type === value
					raise Literal::TypeError.expected(value, to_be_a: attribute.type)
				end
			end

			new_attributes[name] = value.frozen? ? value : value.dup
		end

		copy = dup
		copy.instance_variable_set(:@attributes, @attributes.dup.merge(new_attributes))
		copy.freeze
		copy
	end

	def freeze
		@attributes.each_value(&:freeze)
		super
	end
end
