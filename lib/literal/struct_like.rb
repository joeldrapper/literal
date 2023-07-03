# frozen_string_literal: true

class Literal::StructLike
	extend Literal::Attributes

	protected attr_reader :attributes

	def self.literal_reader(attribute) = attribute.struct_reader

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
