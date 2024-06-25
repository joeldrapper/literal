# frozen_string_literal: true

class Literal::Properties::DataSchema < Literal::Properties::Schema
	def generate_initializer_body(buffer = +"")
		buffer << "properties = self.class.literal_properties.properties_index\n"
		generate_initializer_handle_properties(@sorted_properties, buffer)
		buffer << "after_initialize if respond_to?(:after_initialize)\nfreeze\n"
	end
end
