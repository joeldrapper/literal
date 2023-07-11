# frozen_string_literal: true

module Literal::Attributes
	include Literal::Attributable

	private

	def generate_literal_initializer
		Generators::IVarInitializer.new(literal_attributes).call
	end

	def generate_literal_writer(attribute)
		Generators::IVarWriter.new(attribute).call
	end

	def generate_literal_reader(attribute)
		Generators::IVarReader.new(attribute).call
	end
end
