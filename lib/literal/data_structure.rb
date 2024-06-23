# frozen_string_literal: true

# @api private
class Literal::DataStructure
	extend Literal::Properties

	def self.from_pack(payload)
		object = allocate
		object.marshal_load(payload)
		object
	end

	def ==(other)
		if Literal::DataStructure === other
			to_h == other.to_h
		else
			false
		end
	end

	def hash
		[self.class, to_h].hash
	end

	def [](key)
		instance_variable_get("@#{key}")
	end

	def []=(key, value)
		@literal_properties[key].check(value)
		instance_variable_set("@#{key}", value)
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
end
