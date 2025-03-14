# frozen_string_literal: true

include Literal::Types

test "===" do
	Fixtures::Objects.each do |object|
		refute _Never === object
	end

	refute _Never === nil
end
