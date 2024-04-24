# frozen_string_literal: true

include Literal::Types

test "matches any type apart from nil" do
	Fixtures::Objects.each do |object|
		assert AnyType === object
	end

	refute AnyType === nil
end
