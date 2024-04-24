# frozen_string_literal: true

include Literal::Types

test "===" do
	constraint = _Constraint(Array, size: 3)

	assert constraint === [1, 2, 3]

	refute constraint === [1, 2, 3, 4]
	refute constraint === { a: 1, b: 2, c: 3 }
end

test "== method" do
	constraint = _Constraint(Array, size: 3)
	same_constraint = _Constraint(Array, size: 3)
	different_constraint = _Constraint(Array, size: 4)

	assert constraint == same_constraint
	assert constraint.eql?(same_constraint)
	assert constraint != different_constraint
	assert constraint != nil
	assert constraint != Object.new
end
