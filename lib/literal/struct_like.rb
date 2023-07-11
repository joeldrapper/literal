# frozen_string_literal: true

class Literal::StructLike
	extend Literal::Attributes

	protected attr_reader :attributes

	class << self
		private

		def generate_literal_initializer
			Generators::StructInitializer.new(literal_attributes).call
		end

		def generate_literal_reader(attribute)
			Generators::StructReader.new(attribute).call
		end

		def generate_literal_writer(attribute)
			Generators::StructWriter.new(attribute).call
		end
	end

	def to_h
		@attributes.dup
	end

	def ==(other)
		case other
		when Literal::StructLike
			@attributes == other.attributes
		else
			false
		end
	end
end
