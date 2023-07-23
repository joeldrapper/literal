# frozen_string_literal: true

class Literal::Struct < Literal::Structish
	class << self
		def attribute(name, type, special = nil, reader: :public, writer: :public, positional: false, default: nil)
			super(name, type, special, reader:, writer:, positional:, default:)
		end

		private

		def generate_literal_initializer
			Generators::StructInitializer.new(literal_attributes).call
		end

		def generate_literal_writer(attribute)
			Generators::StructWriter.new(attribute).call
		end

		def generate_literal_reader(attribute)
			Generators::StructReader.new(attribute).call
		end
	end

	def marshal_load(data)
		case data
		when Hash
			@attributes = data[:attributes]
			freeze if data[:frozen?]
		when Array
			@attributes = data[1]
			freeze if data[2]
		end

		@literal_attributes = self.class.literal_attributes
	end

	def marshal_dump
		[2, @attributes, frozen?]
	end
end
