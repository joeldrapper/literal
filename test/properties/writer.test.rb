# frozen_string_literal: true

Example = Literal::Object

test "no writer by default" do
	example = Class.new(Example) do
		prop :example, String
	end

	object = example.new(
		example: "hello",
	)

	expect(object.public_methods).not_to_include(:example=)
	expect(object.protected_methods).not_to_include(:example=)
	expect(object.private_methods).not_to_include(:example=)
end

test "false writer" do
	example = Class.new(Example) do
		prop :example, String, writer: false
	end

	object = example.new(
		example: "hello",
	)

	expect(object.public_methods).not_to_include(:example)
	expect(object.protected_methods).not_to_include(:example)
	expect(object.private_methods).not_to_include(:example)
end

test "private writer" do
	example = Class.new(Example) do
		prop :example, String, writer: :private, reader: :public
	end

	object = example.new(
		example: "hello",
	)

	expect(object.private_methods).to_include(:example=)
	expect(object.__send__(:example=, "world")) == "world"
end

test "protected writer" do
	example = Class.new(Example) do
		prop :example, String, writer: :protected, reader: :public
	end

	object = example.new(
		example: "hello",
	)

	expect(object.protected_methods).to_include(:example=)
	expect(object.__send__(:example=, "world")) == "world"
end

test "public writer" do
	example = Class.new(Example) do
		prop :example, String, writer: :public, reader: :public
	end

	object = example.new(
		example: "hello",
	)

	expect(object.public_methods).to_include(:example=)
	expect(object.example = "world") == "world"
end
