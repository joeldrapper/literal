# frozen_string_literal: true

include Literal::Types

Booleans = Set[true, false]
OtherObjects = Fixtures::Objects - Booleans

test do
	Booleans.each do |value|
		assert BooleanType === value
	end

	OtherObjects.each do |value|
		refute BooleanType === value
	end
end
