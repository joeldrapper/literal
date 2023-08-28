# frozen_string_literal: true

class Literal::Data < Literal::Structish
	class << self
		def attribute(name, type, special = nil, reader: :public, positional: false, default: nil)
			super(name, type, special, reader:, writer: false, positional:, default:)
		end

		private

		def define_literal_methods(attribute)
			literal_extension.module_eval <<~RUBY, __FILE__, __LINE__ + 1
				# frozen_string_literal: true

				#{generate_literal_initializer}

				#{generate_literal_reader(attribute) if attribute.reader?}
			RUBY
		end

		def generate_literal_initializer
			Generators::DataInitializer.new(literal_attributes).call
		end

		def generate_literal_reader(attribute)
			Generators::StructReader.new(attribute).call
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
		copy.instance_variable_set(:@attributes, @attributes.merge(new_attributes))
		copy.freeze
		copy
	end

	def marshal_load(data)
		case data
		when Hash # TODO: Remove this branch.
			@attributes = data[:attributes]
		when Array
			@attributes = data[1]
		end

		@literal_attributes = self.class.literal_attributes
		freeze
	end

	def marshal_dump
		[2, @attributes]
	end
end
