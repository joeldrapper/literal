# frozen_string_literal: true

module Foo
	extend self
	extend Literal::Modifiers

	sig def add(a:, b:)
		a + b
	end, [a: Integer, b: Integer] => Integer

	sig def greet(name)
		"Hello #{name}"
	end, [String] => String

	sig def baz
		"Hi"
	end, [] => Integer
end

test do
	expect(Foo.add(a: 1, b: 2)) == 3
	expect(Foo.greet("Joel")) == "Hello Joel"

	expect { Foo.add(a: "Hi", b: 2) }.to_raise Literal::TypeError do |error|
		expect(error.message) === %(Expected `"Hi"` to be of type: `Integer`.)
	end

	expect { Foo.baz }.to_raise Literal::TypeError do |error|
		expect(error.message) === %(Expected `"Hi"` to be of type: `Integer`.)
	end
end
