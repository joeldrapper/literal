# frozen_string_literal: true

Example = Literal::Object

test "no writer by default" do
	example = Class.new(Example) do
		prop :example, String
	end

	object = example.new(
		example: "hello",
	)

	refute_includes object.public_methods, :example=
	refute_includes object.protected_methods, :example=
	refute_includes object.private_methods, :example=
end

test "false writer" do
	example = Class.new(Example) do
		prop :example, String, writer: false
	end

	object = example.new(
		example: "hello",
	)

	refute_includes object.public_methods, :example
	refute_includes object.protected_methods, :example
	refute_includes object.private_methods, :example
end

test "private writer" do
	example = Class.new(Example) do
		prop :example, String, writer: :private, reader: :public
	end

	object = example.new(
		example: "hello",
	)

	assert_includes object.public_methods, :example
	assert_equal object.__send__(:example), "hello"
end

test "protected writer" do
	example = Class.new(Example) do
		prop :example, String, writer: :protected, reader: :public
	end

	object = example.new(
		example: "hello",
	)

	assert_includes object.protected_methods, :example=
	assert_equal object.__send__(:example=, "world"), "world"
end

test "public writer" do
	example = Class.new(Example) do
		prop :example, String, writer: :public, reader: :public
	end

	object = example.new(
		example: "hello",
	)

	assert_includes object.public_methods, :example=
	assert_equal object.example = "world", "world"
end
