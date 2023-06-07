# frozen_string_literal: true

module Literal::StructAttributes
	include Literal::Attributes

	private

	def literal_initializer_body = <<~RUBY
		@attributes = {
			#{literal_attributes.map(&:mapping).join(', ')}
		}
	RUBY

	def literal_writer(attribute) = attribute.struct_writer
	def literal_reader(attribute) = attribute.struct_reader
end
