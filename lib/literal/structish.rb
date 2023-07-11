# frozen_string_literal: true

class Literal::Structish
	extend Literal::Attributable

	protected attr_reader :attributes

	def to_h
		@attributes.dup
	end

	def ==(other)
		case other
		when Literal::Structish
			@attributes == other.attributes
		else
			false
		end
	end
end
