# frozen_string_literal: true

Example = Literal::Object

test "no reader by default" do
	example = Class.new(Example) do
		prop :example, String
	end

	object = example.new(
		example: "hello",
	)

	refute_includes(object.public_methods, :example)
	refute_includes(object.protected_methods, :example)
	refute_includes(object.private_methods, :example)
end

test "false reader" do
	example = Class.new(Example) do
		prop :example, String, reader: false
	end

	object = example.new(
		example: "hello",
	)

	refute_includes(object.public_methods, :example)
	refute_includes(object.protected_methods, :example)
	refute_includes(object.private_methods, :example)
end

test "private reader" do
	example = Class.new(Example) do
		prop :example, String, reader: :private
	end

	object = example.new(
		example: "hello",
	)

	assert_includes(object.private_methods, :example)
	assert_equal(object.__send__(:example), "hello")
end

test "protected reader" do
	example = Class.new(Example) do
		prop :example, String, reader: :protected
	end

	object = example.new(
		example: "hello",
	)

	assert_includes(object.protected_methods, :example)
	assert_equal(object.__send__(:example), "hello")
end

test "public reader" do
	example = Class.new(Example) do
		prop :example, String, reader: :public
	end

	object = example.new(
		example: "hello",
	)

	assert_includes(object.public_methods, :example)
	assert_equal(object.example, "hello")
end
