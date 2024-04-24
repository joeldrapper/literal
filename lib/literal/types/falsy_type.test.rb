# frozen_string_literal: true

include Literal::Types

test do
	assert FalsyType === false
	assert FalsyType === nil

	Fixtures::TruthyObjects.each do |object|
		refute FalsyType === object
	end
end
