# frozen_string_literal: true

include Literal::Types

describe "with Hash" do
	let def schema = _Schema(name: String, age: Integer)

	test "inspect" do
		expect(schema.inspect) == "_Schema({:name=>String, :age=>Integer})"
	end

	test "===" do
		assert schema === { name: "John", age: 42 }

		refute schema === { name: "John", age: 42, extra: "value" }
		refute schema === { "name" => "John", age: 42 }
		refute schema === { name: "John", age: "42" }
		refute schema === { name: "John" }
		refute schema === {}
		refute schema === []
		refute schema === nil
	end
end

describe "with Array" do
	let def schema = _Schema(String, Integer)

	test "inspect" do
		expect(schema.inspect) == "_Schema([String, Integer])"
	end

	test "===" do
		assert schema === ["John", 42]

		refute schema === ["John", 42, "extra"]
		refute schema === ["John", "42"]
		refute schema === ["John"]
		refute schema === []
		refute schema === {}
		refute schema === nil
	end
end
