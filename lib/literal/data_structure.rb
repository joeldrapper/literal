# frozen_string_literal: true

# @api private
class Literal::DataStructure
	extend Literal::Properties

	def self.from_pack(payload)
		object = allocate
		object.marshal_load(payload)
		object
	end

	def [](key)
		instance_variable_get(:"@#{key}")
	end

	def []=(key, value)
		# TODO: Sync error array w/ generated setter
		@literal_properties[key].check(value) { |c| raise NotImplementedError }
		instance_variable_set(:"@#{key}", value)
	end

	def deconstruct
		to_h.values
	end

	def deconstruct_keys(keys)
		h = to_h
		keys ? h.slice(*keys) : h
	end

	def as_pack
		marshal_dump
	end

	def marshal_load(payload)
		_version, attributes, was_frozen = payload

		attributes.each do |key, value|
			instance_variable_set("@#{key}", value)
		end

		freeze if was_frozen
	end

	def marshal_dump
		[1, to_h, frozen?]
	end

	def self.__generate_literal_methods__(new_property, buffer = +"")
		super
		literal_properties.generate_hash(buffer)
		literal_properties.generate_eq("Literal::DataStructure", buffer)
		buffer
	end
end
