# frozen_string_literal: true

class Literal::Data
	extend Literal::StructAttributes

	def self.attribute(name, type, special = nil, reader: :public, positional: false)
		super(name, type, special, reader:, writer: false, positional:)
	end

	def self.literal_initializer_body = "#{super}; freeze"

	def with(**new_attributes)
		new_attributes.each do |name, value|
			unless (type = @literal_types[name])
				raise Literal::ArgumentError, "Unknown attribute `#{name.inspect}`."
			end

			unless type === value
				raise Literal::TypeError.expected(value, to_be_a: attribute.type)
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
