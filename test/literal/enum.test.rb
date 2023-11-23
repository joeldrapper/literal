# frozen_string_literal: true

extend Literal::Types

class Color < Literal::Enum(Integer)
	Red(0)
	Green(1)
	Blue(3)
	LightRed(4)
end

class Switch < Literal::Enum(_Boolean)
	On(true) do
		def toggle = Switch::Off
	end

	Off(false) do
		def toggle = Switch::On
	end
end

test "handle" do
	output = Color::Red.handle do |c|
		c.when(Color::Red) { "red" }
		c.when(Color::Green) { "green" }
		c.when(Color::Blue) { "blue" }
		c.when(Color::LightRed) { "light red" }
	end

	expect(output) == "red"
end

test "the enum class is frozen" do
	assert Color.frozen?
end

test "the enum class is enumerable" do
	expect(Color).to_be_an Enumerable
	expect(Color.map(&:value)) == [0, 1, 3, 4]
	expect(Color.reject(&:red?)) == [Color::Green, Color::Blue, Color::LightRed]
end

test "type checking" do
	expect {
		class TypeChecking < Literal::Enum(Integer)
			Red("red")
		end
	}.to_raise(Literal::TypeError)
end

test "you can't add members after the initial definition" do
	expect {
		Color::Yellow(4)
	}.to_raise(NoMethodError)
end

test "you can't use the same name twice" do
	expect {
		class SameNameTwice < Literal::Enum(Integer)
			Red(0)
			Red(1)
		end
	}.to_raise(ArgumentError)
end

test "you can't use the same value twice" do
	expect {
		class SameValueTwice < Literal::Enum(Integer)
			Red(0)
			Green(0)
		end
	}.to_raise(ArgumentError)
end

test "the enum members are frozen" do
	assert Color.all?(&:frozen?)
end

test "values" do
	expect(Color.values) == [0, 1, 3, 4]
end

test "predicates" do
	assert Color::Red.red?
	refute Color::Green.red?
	refute Color::Blue.red?
end

test "values are frozen" do
	class ValuesAreFrozen < Literal::Enum(String)
		Foo(+"foo")
	end

	assert ValuesAreFrozen::Foo.value.frozen?
end

test "casting a value" do
	expect(Color[0]) == Color::Red
	expect(Color[1]) == Color::Green
	expect(Color[3]) == Color::Blue
	expect(Color.cast(4)) == Color::LightRed
end

test "to_i is defined on integer enums" do
	expect(Color::Red.to_i) == 0
	refute Switch::On.respond_to?(:to_i)
end

test "enum can be used as a proc to cast values" do
	expect([0, 4].map(&Color)) == [Color::Red, Color::LightRed]
end

test "member singleton methods" do
	expect(Switch::On.toggle) == Switch::Off
end
