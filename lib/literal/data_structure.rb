# frozen_string_literal: true

# @api private
class Literal::DataStructure
	extend Literal::Properties

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
end
