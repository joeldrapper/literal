# frozen_string_literal: true

# @api private
class Literal::Properties::Schema
	include Enumerable

	def initialize(properties_index: {}, sorted_properties: [])
		@properties_index = properties_index
		@sorted_properties = sorted_properties
		@mutex = Mutex.new
	end

	attr_reader :properties_index

	def [](key)
		@properties_index[key]
	end

	def <<(value)
		@mutex.synchronize do
			@properties_index[value.name] = value
			@sorted_properties = @properties_index.values.sort!
		end

		self
	end

	def dup
		self.class.new(
			properties_index: @properties_index.dup,
			sorted_properties: @sorted_properties.dup,
		)
	end

	def each(&)
		@sorted_properties.each(&)
	end

	def size
		@sorted_properties.size
	end

	def generate_initializer(buffer = +"")
		buffer << "def initialize(#{generate_initializer_params})\n"
		generate_initializer_body(buffer)
		buffer << "end\n"
	end

	def generate_to_h(buffer = +"")
		buffer << "def to_h\n" << "{\n"

		sorted_properties = @sorted_properties
		i, n = 0, sorted_properties.size
		while i < n
			property = sorted_properties[i]
			buffer << property.name.name << ": @" << property.name.name << ",\n"
			i += 1
		end

		buffer << "}\n" << "end\n"
	end

	private

	def generate_initializer_params(buffer = +"")
		sorted_properties = @sorted_properties
		i, n = 0, sorted_properties.size
		while i < n
			property = sorted_properties[i]

			case property.kind
			when :*
				buffer << "*" << property.escaped_name
			when :**
				buffer << "**" << property.escaped_name
			when :&
				buffer << "&" << property.escaped_name
			when :positional
				if property.default
					buffer << property.escaped_name << " = Literal::Null"
				elsif property.type === nil # optional
					buffer << property.escaped_name << " = nil"
				else # required
					buffer << property.escaped_name
				end
			else # keyword
				if property.default
					buffer << property.name.name << ": Literal::Null"
				elsif property.type === nil
					buffer << property.name.name << " nil" # optional
				else # required
					buffer << property.name.name << ":"
				end
			end

			i += 1
			buffer << ", " if i < n
		end

		buffer
	end

	def generate_initializer_body(buffer = +"")
		buffer << "properties = self.class.literal_properties.properties_index\n"
		generate_initializer_handle_properties(@sorted_properties, buffer)
		buffer << "after_initialize if respond_to?(:after_initialize)\n"
	end

	def generate_initializer_handle_properties(properties, buffer = +"")
		i, n = 0, properties.size
		while i < n
			properties[i].generate_initializer_handle_property(buffer)
			i += 1
		end

		buffer
	end
end
