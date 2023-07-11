# frozen_string_literal: true

class Literal::Data < Literal::StructLike
	class << self
		def attribute(name, type, special = nil, reader: :public, positional: false, default: nil)
			super(name, type, special, reader:, writer: false, positional:, default:)
		end

		def generate_literal_initializer
			Generators::DataInitializer.new(literal_attributes).call
		end
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

				unless value.frozen?
					new_attributes[name] = value.dup.tap(&:freeze)
				end
			end

			new_attributes[name] = value.frozen? ? value : value.dup
		end

		copy = dup
		copy.instance_variable_set(:@attributes, @attributes.dup.merge(new_attributes))
		copy.freeze
		copy
	end

	def marshal_load(data)
		@attributes = data[:attributes]
		@literal_attributes = self.class.literal_attributes
		freeze
	end

	def marshal_dump
		{
			v: 1,
			attributes: @attributes
		}
	end
end
