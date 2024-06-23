# frozen_string_literal: true

class Literal::Rails::StructuredDataSerializer < ActiveJob::Serializers::ObjectSerializer
	def serialize?(object)
		Literal::DataStructure === object
	end

	def serialize(object)
		super(
			"class" => object.class.name,
			"data" => object.as_pack,
		)
	end

	def deserialize(payload)
		payload["class"].constantize.from_pack(
			payload["data"],
		)
	end
end
