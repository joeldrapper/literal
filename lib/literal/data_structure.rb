# frozen_string_literal: true

# @api private
class Literal::DataStructure
	extend Literal::Properties

	def self.from_pack(payload)
		object = allocate
		object.marshal_load(payload)
		object
	end

	def to_h
		{}
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

	def hash
		self.class.hash
	end

	def ==(other)
		other.is_a?(self.class) && other.class.literal_properties.empty?
	end
	alias eql? ==

	def self.__generate_literal_methods__(new_property, buffer = +"")
		super
		literal_properties.generate_hash(buffer)
		literal_properties.generate_eq(buffer)
		buffer
	end
end
