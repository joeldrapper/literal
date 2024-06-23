# frozen_string_literal: true

class Literal::Data < Literal::DataStructure
	class << self
		def prop(name, type, kind = :keyword, reader: :public, default: nil)
			super(name, type, kind, reader:, writer: false, default:)
		end

		def literal_properties
			return @literal_properties if defined?(@literal_properties)

			if superclass.is_a?(Literal::Data)
				@literal_properties = superclass.literal_properties.dup
			else
				@literal_properties = Literal::Properties::DataSchema.new
			end
		end

		private

		def __literal_property_class__
			Literal::DataProperty
		end
	end
end
