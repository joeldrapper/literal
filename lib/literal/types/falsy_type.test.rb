# frozen_string_literal: true

include Literal::Types

FalsyObjects = Set[false, nil]
TruthyObject = Fixtures::Objects - FalsyObjects

test do
	FalsyObjects.each do |object|
		assert FalsyType === object
	end

	TruthyObject.each do |object|
		refute FalsyType === object
	end
end
