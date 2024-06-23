# frozen_string_literal: true

class Literal::Rails::EnumSerializer < ActiveJob::Serializers::ObjectSerializer
	def serialize?(object)
		Literal::Enum === object
	end

	def serialize(object)
		super(
			"class" => object.class.name,
			"value" => object.value,
		)
	end

	def deserialize(payload)
		payload["class"].constantize[
			payload["value"]
		]
	end
end
