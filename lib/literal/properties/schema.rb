# frozen_string_literal: true

# @api private
class Literal::Properties::Schema
	include Enumerable

	def initialize(properties_index: {}, sorted_properties: [])
		@properties_index = properties_index
		@sorted_properties = sorted_properties
		@mutex = Mutex.new
	end

	def [](key)
		@properties_index[key.to_s]
	end

	def <<(value)
		@mutex.synchronize do
			@properties_index[value.name] = value
			@sorted_properties = @properties_index.values
			@sorted_properties.sort!
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

	def generate_initializer
		[
			"def initialize(#{generate_initializer_params})",
			generate_initializer_body,
			"end",
		].join("\n")
	end

	def generate_to_h
		[
			"def to_h",
			"{",
			@sorted_properties.each.map do |property|
				"#{property.name}: @#{property.name},"
			end,
			"}",
			"end",
		].join("\n")
	end

	private

	def generate_initializer_params
		@sorted_properties.each.map do |property|
			case property.kind
			when :*
				"*#{property.escaped_name}"
			when :**
				"**#{property.escaped_name}"
			when :&
				"&#{property.escaped_name}"
			when :positional
				if property.default
					"#{property.escaped_name} = Literal::Null"
				elsif property.type === nil # optional
					"#{property.escaped_name} = nil"
				else # required
					property.escaped_name
				end
			else # keyword
				if property.default
					"#{property.name}: Literal::Null"
				elsif property.type === nil
					"#{property.name}: nil" # optional
				else # required
					"#{property.name}:"
				end
			end
		end.join(", ")
	end

	def generate_initializer_body(buffer = +"")
		buffer << "@literal_properties = self.class.literal_properties\n"
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
