# frozen_string_literal: true

class Literal::Rails::EnumSerializer < ActiveJob::Serializers::ObjectSerializer
	def serialize?(object)
		Literal::Enum === object
	end

	def serialize(object)
		super([
			0,
			object.class.name,
			object.value,
		])
	end

	def deserialize(payload)
		_version, class_name, value = payload
		class_name.constantize[value]
	end
end
