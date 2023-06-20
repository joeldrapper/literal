# frozen_string_literal: true

use ToChange

describe "writer option" do
	test "when falsy" do
		example = build_attributes_class {
			attribute :foo, String
		}.new(foo: "Hello")

		refute example.public_methods.include?(:foo=)
		refute example.protected_methods.include?(:foo=)
		refute example.private_methods.include?(:foo=)

		expect { example.foo = "Bar" }.to_raise NoMethodError
	end

	test "when public" do
		example = build_attributes_class {
			attribute :foo, String, writer: :public
		}.new(foo: "Hello")

		assert example.public_methods.include?(:foo=)

		expect { example.instance_variable_get(:@foo) }.to_change(from: "Hello", to: "Bar") {
			expect(example.foo = "Bar") == "Bar"
		}

		expect { example.foo = 1 }.to_raise Literal::TypeError
	end

	test "when protected" do
		example = build_attributes_class {
			attribute :foo, String, writer: :protected
		}.new(foo: "Hello")

		assert example.protected_methods.include?(:foo=)
		expect { example.foo = "Bar" }.to_raise NoMethodError
	end

	test "when private" do
		example = build_attributes_class {
			attribute :foo, String, writer: :private
		}.new(foo: "Hello")

		assert example.private_methods.include?(:foo=)
		expect { example.foo = "Bar" }.to_raise NoMethodError
	end
end

describe "reader option" do
	test "when falsy" do
		example = build_attributes_class {
			attribute :foo, String
		}.new(foo: "Hello")

		refute example.public_methods.include?(:foo)
		refute example.protected_methods.include?(:foo)
		refute example.private_methods.include?(:foo)

		expect { example.foo }.to_raise NoMethodError
	end

	test "when public" do
		example = build_attributes_class {
			attribute :foo, String, reader: :public
		}.new(foo: "Hello")

		assert example.public_methods.include?(:foo)
		expect(example.foo) == "Hello"
	end

	test "when protected" do
		example = build_attributes_class {
			attribute :foo, String, reader: :protected
		}.new(foo: "Hello")

		assert example.protected_methods.include?(:foo)
		expect { example.foo }.to_raise NoMethodError
	end

	test "when private" do
		example = build_attributes_class {
			attribute :foo, String, reader: :private
		}.new(foo: "Hello")

		assert example.private_methods.include?(:foo)
		expect { example.foo }.to_raise NoMethodError
	end
end

describe "default option" do
	test "with frozen value" do
		example = build_attributes_class {
			attribute :foo, String, default: "Hello", reader: :public
		}.new

		expect(example.foo) == "Hello"
	end

	test "with mutable value" do
		expect {
			build_attributes_class { attribute :foo, String, default: +"Hello" }
		}.to_raise Literal::ArgumentError
	end

	test "with Proc" do
		example = build_attributes_class {
			attribute :foo, String, default: -> { +"Hello" }, reader: :public
		}.new

		expect(example.foo) == "Hello"
	end

	test "when overridden" do
		example = build_attributes_class {
			attribute :foo, String, default: "Hello", reader: :public
		}.new(foo: "World")

		expect(example.foo) == "World"
	end

	test "when overridden with nil" do
		example = build_attributes_class {
			attribute :foo, _Nilable(String), default: "Hello", reader: :public
		}.new(foo: nil)

		expect(example.foo) == nil
	end
end

test "with Ruby keywords" do
	example = build_attributes_class {
		attribute :if, String, reader: :public
	}.new(if: "Hello")

	expect(example.if) == "Hello"
end

test "with `class` name and reader" do
	expect {
		build_attributes_class { attribute :class, String, reader: :public }
	}.to_raise Literal::ArgumentError
end

test "inheritance" do
	example = Class.new(
		build_attributes_class { attribute :foo, String, reader: :public }
	).new(foo: "Hello")

	expect(example.foo) == "Hello"
end

if Literal::TYPE_CHECKS
	test "does a type check" do
		expect {
			example = build_attributes_class {
				attribute :foo, String, reader: :public
			}.new(foo: 1)
		}.to_raise Literal::TypeError
	end
end

def build_attributes_class(&)
	Class.new do
		extend Literal::Attributes
		class_eval(&)
	end
end
