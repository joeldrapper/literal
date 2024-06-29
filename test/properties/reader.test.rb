# frozen_string_literal: true

Example = Literal::Object

test "no reader by default" do
	example = Class.new(Example) do
		prop :example, String
	end

	object = example.new(
		example: "hello",
	)

	expect(object.public_methods).not_to_include(:example)
	expect(object.protected_methods).not_to_include(:example)
	expect(object.private_methods).not_to_include(:example)
end

test "false reader" do
	example = Class.new(Example) do
		prop :example, String, reader: false
	end

	object = example.new(
		example: "hello",
	)

	expect(object.public_methods).not_to_include(:example)
	expect(object.protected_methods).not_to_include(:example)
	expect(object.private_methods).not_to_include(:example)
end

test "private reader" do
	example = Class.new(Example) do
		prop :example, String, reader: :private
	end

	object = example.new(
		example: "hello",
	)

	expect(object.private_methods).to_include(:example)
	expect(object.__send__(:example)) == "hello"
end

test "protected reader" do
	example = Class.new(Example) do
		prop :example, String, reader: :protected
	end

	object = example.new(
		example: "hello",
	)

	expect(object.protected_methods).to_include(:example)
	expect(object.__send__(:example)) == "hello"
end

test "public reader" do
	example = Class.new(Example) do
		prop :example, String, reader: :public
	end

	object = example.new(
		example: "hello",
	)

	expect(object.public_methods).to_include(:example)
	expect(object.example) == ("hello")
end
