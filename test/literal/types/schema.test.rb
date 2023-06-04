# frozen_string_literal: true

include Literal::Types

test "Hash Schema" do
	assert _Schema(name: String, age: Integer) === { name: "John", age: 42 }

	refute _Schema(name: String, age: Integer) === { name: "John", age: 42, extra: "value" }
	refute _Schema(name: String, age: Integer) === { "name" => "John", age: 42 }
	refute _Schema(name: String, age: Integer) === { name: "John", age: "42" }
	refute _Schema(name: String, age: Integer) === { name: "John" }
	refute _Schema(name: String, age: Integer) === {}
	refute _Schema(name: String, age: Integer) === []
end

test "Array Schema" do
	assert _Schema(String, Integer) === ["John", 42]

	refute _Schema(String, Integer) === ["John", 42, "extra"]
	refute _Schema(String, Integer) === ["John", "42"]
	refute _Schema(String, Integer) === ["John"]
	refute _Schema(String, Integer) === []
	refute _Schema(String, Integer) === {}
end
