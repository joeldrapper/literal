# frozen_string_literal: true

include Literal::Types

def schema = _Shape(Hash, name: String, age: Integer)

test "inspect" do
	expect(schema.inspect) == "_Shape({:name=>String, :age=>Integer})"
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
