# frozen_string_literal: true

set_temporary_name("Quickdraw::Context(in #{__FILE__})") if respond_to?(:set_temporary_name)

Example = Literal::Object

test "positional params are required by default" do
	example = Class.new(Example) do
		prop :example, String, :positional
	end

	expect { example.new }.to_raise(ArgumentError)
	expect { example.new("Hello") }.not_to_raise
end

test "keyword params are required by default" do
	example = Class.new(Example) do
		prop :example, String
	end

	expect { example.new }.to_raise(ArgumentError)
	expect { example.new(example: "Hello") }.not_to_raise
end

test "nilable positional params are optional" do
	example = Class.new(Example) do
		prop :example, _Nilable(String), :positional
	end

	expect { example.new }.not_to_raise
	expect { example.new("Hello") }.not_to_raise
end

test "nilable keyword params are optional" do
	example = Class.new(Example) do
		prop :example, _Nilable(String)
	end

	expect { example.new }.not_to_raise
	expect { example.new(example: "Hello") }.not_to_raise
end

test "positional splats are optional" do
	example = Class.new(Example) do
		prop :example, _Array(String), :*
	end

	expect { example.new }.not_to_raise
	expect { example.new("Hello") }.not_to_raise
	expect { example.new("Hello", "World") }.not_to_raise
end

test "keyword splats are optional" do
	example = Class.new(Example) do
		prop :example, _Hash(Symbol, String), :**
	end

	expect { example.new }.not_to_raise
	expect { example.new(example: "Hello") }.not_to_raise
	expect { example.new(example: "Hello", world: "World") }.not_to_raise
end

test "block params are required by default" do
	example = Class.new(Example) do
		prop :example, Proc, :&
	end

	expect { example.new }.to_raise(Literal::TypeError)
	expect { example.new { "Hello" } }.not_to_raise
end

test "nilable block params are optional" do
	example = Class.new(Example) do
		prop :example, _Nilable(Proc), :&
	end

	expect { example.new }.not_to_raise
	expect { example.new { "Hello" } }.not_to_raise
end

class Person
	extend Literal::Properties

	prop :name, String, :positional, reader: :public
	prop :age, Integer, reader: :public
end

class Random
	extend Literal::Properties
	prop :begin, Integer, :positional, reader: :public
end

class WithDefaultBlock
	extend Literal::Properties
	prop :block, Proc, :&, reader: :public, default: -> { proc { "Hello" } }
end

class WithNilableType
	extend Literal::Properties
	prop :name, Literal::Types::NilableType.new(String), :positional
end

class Empty
	extend Literal::Properties
end

test "empty initializer" do
	expect { Empty.new }.not_to_raise
end

test do
	person = Person.new("John", age: 30)

	expect(person.name) == "John"
	expect(person.age) == 30
end

test "initializer type check" do
	expect { Person.new(1, age: "Joel") }.to_raise(Literal::TypeError) { |error|
		expect(error.message) == <<~ERROR
   Type mismatch

   #{Person}#initialize (from #{error.backtrace[1]})
     name
       Expected: String
       Actual (Integer): 1
ERROR
	}
end

test "initializer keyword check" do
	random = Random.new(1)

	expect(random.begin) == 1
end

test "default block" do
	object = WithDefaultBlock.new
	expect(object.block.call) == "Hello"

	object = WithDefaultBlock.new { "World" }
	expect(object.block.call) == "World"
end

test "properties are enumerable" do
	props = Person.literal_properties
	expect(props.size) == 2
	expect(props.map(&:name)) == [:name, :age]

	props = Empty.literal_properties
	expect(props.size) == 0
end

test "introspection" do
	prop1, prop2 = *Person.literal_properties

	expect(prop1.name) == :name
	expect(prop1.type) == String
	assert(prop1.positional?) { "Expected name to be kind :positional" }
	refute(prop1.keyword?) { "Expected name to not be kind :keyword" }
	refute(prop1.block?) { "Expected name to not be kind :&" }
	refute(prop1.splat?) { "Expected name to not be bind :*" }
	refute(prop1.double_splat?) { "Expected name to not be kind :**" }
	assert(prop1.required?) { "Expected name to be required" }
	refute(prop1.optional?) { "Expected name to not be optional" }

	expect(prop2.name) == :age
	expect(prop2.type) == Integer
	assert(prop2.keyword?) { "Expected age to be kind :keyword" }
	assert(prop2.required?) { "Expected age to be required" }

	props = WithDefaultBlock.literal_properties
	prop_block = props.first
	assert(prop_block.block?) { "Expected block to be kind :&" }
	assert(prop_block.optional?) { "Expected block to be optional" }

	props = WithNilableType.literal_properties
	prop_name = props.first
	assert(prop_name.optional?) { "Expected name to be optional" }
end

test "after initialize callback" do
	callback_called = false

	example = Class.new do
		extend Literal::Properties

		prop :name, String

		define_method :after_initialize do
			callback_called = true
		end
	end

	example.new(name: "John")

	assert callback_called

	callback_called = false

	empty = Class.new do
		extend Literal::Properties

		define_method :after_initialize do
			callback_called = true
		end
	end

	empty.new

	assert callback_called
end

class Friend < Person
	prop :age, Float, reader: :public
end

test "inheritance" do
	friend = Friend.new("John", age: 30.5)

	expect(friend.name) == "John"
	expect(friend.age) > 30
end

class WithPredicate
	extend Literal::Properties

	prop :enabled, _Boolean, predicate: :public
end

test "predicates" do
	enabled = WithPredicate.new(enabled: true)
	disabled = WithPredicate.new(enabled: false)

	expect(enabled.enabled?) == true
	expect(disabled.enabled?) == false
end

class WithWriters < Example
	extend Literal::Properties

	prop :example, _Nilable(String), writer: :public
	prop :a, _Nilable(_Array(String)), writer: :public
end

test "writer type error" do
	instance = WithWriters.new

	expect { instance.example = 0 }.to_raise(Literal::TypeError) { |error|
		expect(error.message) == <<~ERROR
			Type mismatch

			#{WithWriters}#example=(value) (from #{error.backtrace[1]})
			  Expected: _Nilable(String)
			  Actual (Integer): 0
ERROR
	}

	expect { instance.a = [1] }.to_raise(Literal::TypeError) { |error|
	expect(error.message) == <<~ERROR
		Type mismatch

		#{WithWriters}#a=(value) (from #{error.backtrace[1]})
		    [0]
		      Expected: String
		      Actual (Integer): 1
	ERROR
	}
end

class Family
	extend Literal::Properties

	prop :members, _Array(_Map(person: Person, role: Symbol)), :positional, reader: :public
	prop :last_reunion_year, _Nilable(Integer)
end

test "nested properties raise in initializer" do
	expect do
		Family.new(
			[
				{
					person: Person.new("Json", age: 1),
					role: 1,
				},
				{
					person: Person.new("John", age: 30),
					role: "Father",
				},
				{
					1 => 2,
				},
			],
		)
	end.to_raise(Literal::TypeError) do |error|
		expect(error.message) == <<~ERROR
			Type mismatch

			#{Family}#initialize (from #{error.backtrace[1]})
			  members
			    [0]
			      [:role]
			        Expected: Symbol
			        Actual (Integer): 1
			    [1]
			      [:role]
			        Expected: Symbol
			        Actual (String): "Father"
			    [2]
			      []
			        Expected: :person
			        Actual (NilClass): nil
			      []
			        Expected: :role
			        Actual (NilClass): nil
		ERROR
	end

	expect { Family.new([1]) }.to_raise(Literal::TypeError) { |error|
			expect(error.message) == <<~ERROR
    Type mismatch

    #{Family}#initialize (from #{error.backtrace[1]})
      members
        [0]
          Expected: _Map(#{{ person: Person, role: Symbol }})
          Actual (Integer): 1
ERROR
	}

	expect { Family.new([], last_reunion_year: :two_thousand) }.to_raise(Literal::TypeError) { |error|
		expect(error.message) == <<~ERROR
   Type mismatch

   #{Family}#initialize (from #{error.backtrace[1]})
     last_reunion_year:
       Expected: _Nilable(Integer)
       Actual (Symbol): :two_thousand
ERROR
	}
end

test "nested properties succeed in initializer" do
	expect do
		Family.new(
			[
				{
					person: Person.new("Json", age: 1),
					role: :son,
				},
				{
					person: Person.new("John", age: 30),
					role: :brother,
				},
			],
		)
	end.not_to_raise
	expect { Family.new([]) }.not_to_raise
	expect { Family.new([], last_reunion_year: 0) }.not_to_raise
end

test "#to_h" do
		person = Person.new("John", age: 30)
		expect(person.to_h) == { name: "John", age: 30 }

		empty = Empty.new
		expect(empty.to_h) == {}
end
