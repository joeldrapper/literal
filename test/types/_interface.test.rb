# frozen_string_literal: true

include Literal::Types

test "===" do
	enumerable_interface = _Interface(:each, :map, :select)

	assert enumerable_interface === []
	assert enumerable_interface === Set.new

	refute enumerable_interface === 42
	refute enumerable_interface === "string"
	refute enumerable_interface === nil
end

test "hierarchy" do
	assert_subtype _Interface(:a), _Interface(:a)
	assert_subtype _Interface(:a, :b), _Interface(:a)
	assert_subtype _Interface(:a, :b), _Interface(:a, :b)
	assert_subtype _Callable, _Interface(:call)
	assert_subtype _Procable, _Interface(:to_proc)

	refute_subtype _Interface(:b), _Interface(:a)
	refute_subtype _Interface(:a), _Interface(:a, :b)
	refute_subtype Proc, _Interface(:to_proc, :random_method)
end

test "error message" do
	error = assert_raises Literal::TypeError do
		Literal.check(nil, _Interface(:each, :map, :select))
	end

	assert_equal error.message, <<~MSG
  Type mismatch

    Expected: _Interface(:each, :map, :select)
    Actual (NilClass): nil
	MSG
end
