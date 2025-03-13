# frozen_string_literal: true

include Literal::Types

def expect_type_error(expected:, actual:, message:)
	error = assert_raises(Literal::TypeError) do
		Literal.check(expected:, actual:)
	end

	assert_equal error.message, message
end

test "_Deferred" do
	recursive = _Hash(
		String,
		_Deferred { recursive }
	)

	assert recursive === {
		"a" => {
			"b" => {
				"c" => {
					"d" => {
						"e" => {
							"f" => {
								"g" => {},
							},
						},
					},
				},
			},
		},
	}

	refute recursive === {
		"a" => {
			"b" => { 1 => {} },
		},
	}

	assert _Deferred { Numeric } >= Integer
	assert _Deferred { Numeric } >= _Deferred { Integer }
end

test "_Any" do
	Fixtures::Objects.each do |object|
		assert _Any === object
	end

	refute _Any === nil

	assert _Any >= _Any
	assert _Any >= String
	assert _Any >= "Hello"
	assert _Any >= 1

	refute _Any >= nil
	refute _Any >= Object
	refute _Any >= _Nilable(_Any)
	refute _Any >= _Nilable(String)
end

test "_Array" do
	assert _Array(String) === []
	assert _Array(String) === ["a", "b", "c"]

	refute _Array(String) === ["a", "b", 42]
end

test "_Boolean" do
	assert _Boolean === true
	assert _Boolean === false

	refute _Boolean === nil

	assert _Boolean >= true
	assert _Boolean >= false
	refute _Boolean >= nil
	assert _Boolean >= _Boolean
end

test "_Callable" do
	assert _Callable === -> {}
	assert _Callable === method(:puts)

	refute _Callable === nil

	assert _Callable >= Proc
	assert _Callable >= Method
	assert _Callable >= _Callable

	assert _Callable >= _Intersection(Object, _Callable)
	assert _Callable >= _String(_Callable)

	assert _Callable >= _Interface(:call, :to_s)

	refute _Callable >= String
	refute _Callable >= Object
end

test "_Class" do
	assert _Class(Enumerable) === Array

	refute _Class(Enumerable) === []
	refute _Class(Enumerable) === String
	refute _Class(Enumerable) === Enumerable

	assert _Class(Enumerable) >= _Class(Array)
	assert _Class(Enumerable) >= _Class(Enumerable)
	assert _Class(Enumerable) >= _Descendant(Array)
	assert _Class(Array) >= _Descendant(Array)

	refute _Class(Enumerable) >= _Descendant(Enumerable)
	refute _Class(Enumerable) >= Enumerable
	refute _Class(Enumerable) >= Class
end

test "_Constraint with object constraints" do
	age_constraint = _Constraint(Integer, 18..)

	assert age_constraint === 18

	refute age_constraint === 17
	refute age_constraint === 17.5

	expect_type_error(expected: age_constraint, actual: 17, message: <<~MSG)
		Type mismatch

		    _Constraint(Integer, 18..)
		      Expected: 18..
		      Actual (Integer): 17
	MSG
	expect_type_error(expected: age_constraint, actual: 18.5, message: <<~MSG)
		Type mismatch

		    _Constraint(Integer, 18..)
		      Expected: Integer
		      Actual (Float): 18.5
	MSG
end

test "_Constraint with property constraints" do
	age_constraint = _Constraint(Array, size: 2..3)

	assert age_constraint === [1, 2]
	assert age_constraint === [1, 2, 3]

	refute age_constraint === [1]
	refute age_constraint === [1, 2, 3, 4]
	refute age_constraint === Set[1, 2]

	expect_type_error(expected: age_constraint, actual: [], message: <<~MSG)
		Type mismatch

		    .size
		      Expected: 2..3
		      Actual (Integer): 0
	MSG
	expect_type_error(expected: age_constraint, actual: nil, message: <<~MSG)
		Type mismatch

		    _Constraint(Array, size: 2..3)
		      Expected: Array
		      Actual (NilClass): nil
	MSG
	expect_type_error(expected: _Constraint(String, foo: 1, size: Integer), actual: "string", message: <<~MSG)
		Type mismatch

		  Expected: _Constraint(String, foo: 1, size: Integer)
		  Actual (String): "string"
	MSG

	assert _Constraint(String) >= _Constraint(String)
	assert _Constraint(_Array(Enumerable)) >= _Constraint(_Array(Array))
	assert _Constraint(Array, size: 1..5) >= _Constraint(Array, size: 1..5)
	assert _Constraint(Array, size: 1..3) >= _Constraint(Array, size: 1..2)
	assert _Constraint(Enumerable, Array) >= _Intersection(Array)
	assert _Constraint(_Array(Enumerable), name: _String(size: 1..5)) >= _Constraint(_Array(Enumerable), name: _String(size: 1..5))

	refute _Constraint(Array, size: 1..2) >= _Constraint(Array, size: 1..3)
	refute _Constraint(String, size: 4) >= _Constraint(String, size: 1)
end

test "_Date" do
	assert _Date(_Interface(:to_date)) === Date.today
	assert _Date(Date.today) === Date.today
	assert _Date((Date.today)..) === Date.today + 1

	refute _Date(_Interface(:non_existing_method)) === Date.today
	refute _Date(Date.today) === "2025-01-13"
	refute _Date(Date.today) === nil
	refute _Date((Date.today)..) === Date.today - 1

	assert _Date(year: 2025) === Date.new(2025, 1, 13)
	refute _Date(year: 2025) === Date.new(2024, 1, 13)

	assert _Date(DateTime, _Interface(:to_datetime)) === DateTime.now
	assert _Date(DateTime, year: 2025) === DateTime.new(2025, 1, 13)
	refute _Date(DateTime, year: 2025) === Date.new(2025, 1, 13)
end

test "_Descendant" do
	assert _Descendant(Enumerable) === Array
	assert _Descendant(Enumerable) === Set

	refute _Descendant(Enumerable) === []
	refute _Descendant(Enumerable) === String

	assert _Descendant(Enumerable) >= _Descendant(Array)
	assert _Descendant(Enumerable) >= _Descendant(Set)
	refute _Descendant(Enumerable) >= _Descendant(String)
end

test "_Enumerable" do
	assert _Enumerable(String) === ["a", "b", "c"]
	assert _Enumerable(Integer) === Set[1, 2, 3]

	refute _Enumerable(String) === [1, "a", :symbol]

	assert _Enumerable(Enumerable) >= _Enumerable(Array)
	assert _Enumerable(Enumerable) >= _Enumerable(Set)

	refute _Enumerable(Enumerable) >= _Enumerable(String)
end

test "_Falsy" do
	falsy_objects = Set[false, nil]
	truthy_objects = Fixtures::Objects - falsy_objects

	falsy_objects.each do |object|
		assert _Falsy === object
	end

	truthy_objects.each do |object|
		refute _Falsy === object
	end

	assert _Falsy >= _Falsy
	assert _Falsy >= false
	assert _Falsy >= nil

	refute _Falsy >= true
	refute _Falsy >= 0
	refute _Falsy >= "string"
end

test "_Float" do
	assert _Float(18.0..) === 18.0
	assert _Float(18.0..) === 19.5

	refute _Float(18.0..) === 17.99
	refute _Float(18.0..) === 42
	refute _Float(18.0..) === "string"
	refute _Float(18.0..) === nil
end

test "_Frozen" do
	assert _Frozen(Array) === [].freeze
	assert _Frozen(String) === "immutable"

	refute _Frozen(Array) === []
	refute _Frozen(String) === +"mutable"
	refute _Frozen(Array) === nil
	assert _Frozen(Enumerable) >= _Constraint(Array, frozen?: true)
end

test "_Hash" do
	assert _Hash(String, Integer) === { "a" => 1, "b" => 2 }
	assert _Hash(Symbol, String) === { foo: "bar", baz: "qux" }

	refute _Hash(String, Integer) === { "a" => "1", "b" => 2 }
	refute _Hash(String, Integer) === { 1 => 2, 3 => 4 }
	refute _Hash(Symbol, String) === { "foo" => "bar", :baz => "qux" }

	assert _Hash(String, Numeric) >= _Hash(String, Integer)
	assert _Hash(Numeric, String) >= _Hash(Integer, String)
	assert _Hash(Symbol, Integer) >= _Hash(Symbol, Integer)
	refute _Hash(Symbol, Integer) >= _Hash(Symbol, Numeric)

	expect_type_error(expected: _Hash(Symbol, Integer), actual: { 1 => 2, :a => :b, :d => 2 }, message: <<~MSG)
  Type mismatch

      []
        Expected: Symbol
        Actual (Integer): 1
      [:a]
        Expected: Integer
        Actual (Symbol): :b
		MSG
	expect_type_error(expected: _Hash(Symbol, Integer), actual: nil, message: <<~MSG)
  Type mismatch

    Expected: _Hash(Symbol, Integer)
    Actual (NilClass): nil
	MSG
end

test "_Integer" do
	assert _Integer(18..) === 18
	assert _Integer(18..) === 19

	refute _Integer(18..) === 17
	refute _Integer(18..) === 18.5
	refute _Integer(18..) === "string"
	refute _Integer(18..) === nil
end

test "_Interface" do
	enumerable_interface = _Interface(:each, :map, :select)

	assert enumerable_interface === []
	assert enumerable_interface === Set.new

	refute enumerable_interface === 42
	refute enumerable_interface === "string"
	refute enumerable_interface === nil

	expect_type_error(expected: enumerable_interface, actual: nil, message: <<~MSG)
		Type mismatch

		  Expected: _Interface(:each, :map, :select)
		  Actual (NilClass): nil
	MSG

	assert _Interface(:a) >= _Interface(:a)
	assert _Interface(:a) >= _Interface(:a, :b)
	assert _Interface(:a, :b) >= _Interface(:a, :b)
	refute _Interface(:a, :b) >= _Interface(:a)
	refute _Interface(:a) >= _Interface(:b)
	assert _Interface(:call) >= _Callable
	assert _Interface(:to_proc) >= _Procable
	refute _Interface(:to_proc, :random_method) >= Proc
end

test "_Intersection" do
	type = _Intersection(
		_Interface(:size),
		_Interface(:each),
	)

	assert type === []
	assert type === Set.new

	refute type === "string"

	expect_type_error(actual: "string", expected: type, message: <<~MSG)
  Type mismatch

      _Intersection(_Interface(:size), _Interface(:each))
        Expected: _Interface(:each)
        Actual (String): "string"
		MSG

	assert _Intersection(String) >= _Intersection(String)
	assert _Intersection(String) >= _Constraint(String, size: 1..5)

	refute _Intersection(String) >= _Constraint(Integer, size: 1..2)
end

test "_JSONData" do
	assert _JSONData === "string"
	assert _JSONData === 42
	assert _JSONData === 3.14
	assert _JSONData === true
	assert _JSONData === false
	assert _JSONData === nil
	assert _JSONData === { "key" => "value", "number" => 42 }
	assert _JSONData === [1, "two", 3.0, true, false, nil]

	assert _JSONData === { "nested_array" => [1, "two", { "key" => "value" }] }
	assert _JSONData === { "nested_hash" => { "key1" => "value1", "key2" => [1, 2, 3] } }
	assert _JSONData === [{ "key" => "value" }, [1, 2, 3], "string"]

	refute _JSONData === Object.new
	refute _JSONData === Set.new
	refute _JSONData === { key: "value" }
	refute _JSONData === [1, :symbol, "three"]
	refute _JSONData === { "nested_array" => [1, :symbol, { "key" => "value" }] }
	refute _JSONData === { "nested_hash" => { "key1" => "value1", "key2" => [1, :symbol, 3] } }
	refute _JSONData === [{ "key" => :value }, [1, 2, 3], "string"]

	assert _JSONData >= _JSONData
	assert _JSONData >= _Array(_JSONData)
	assert _JSONData >= _Hash(_JSONData, _JSONData)
	assert _JSONData >= String
	assert _JSONData >= _String(length: 10)
	assert _JSONData >= Float
	assert _JSONData >= _Float(5..10)
	assert _JSONData >= Integer
	assert _JSONData >= _Integer(5..10)
	assert _JSONData >= true
	assert _JSONData >= false
	assert _JSONData >= nil

	refute _JSONData >= Array # not compatible since we don’t know what’s inside the array
	refute _JSONData >= Hash # same as above

	expect_type_error(actual: { :key => "value", "string" => "string", "symbol" => :symbol, "array" => [1, 2, 3, :symbol], "hash" => { "key" => "value", "symbol" => :symbol } }, expected: _JSONData, message: <<~MSG)
		Type mismatch

		    []
		      Expected: String
		      Actual (Symbol): :key
		    ["symbol"]
		      Expected: _JSONData
		      Actual (Symbol): :symbol
		    ["array"]
		      [3]
		        Expected: _JSONData
		        Actual (Symbol): :symbol
		    ["hash"]
		      ["symbol"]
		        Expected: _JSONData
		        Actual (Symbol): :symbol
	MSG
end

test "_Lambda" do
	assert _Lambda === -> {}
	assert _Lambda === -> (arg) { arg }
	assert _Lambda === lambda {}

	refute _Lambda === proc {}
end

test "_Map" do
	map = _Map(name: String, age: Integer)

	assert map === { name: "Alice", age: 42 }
	assert map === { name: "Bob", age: 18 }

	refute map === { name: "Alice", age: "42" }
	refute map === { name: "Bob", age: nil }
	refute map === { name: "Charlie" }
	refute map === { age: 30 }

	assert _Map(a: Enumerable, b: Numeric) >= _Map(a: Array, b: Integer, foo: String)
	refute _Map(a: Enumerable, b: Numeric) >= _Map(a: Array)
	refute _Map(a: Enumerable, b: Numeric) >= _Map(a: String, b: Integer)
	refute _Map(a: String) >= nil

	expect_type_error(expected: map, actual: { name: "Alice", age: "42" }, message: <<~MSG)
		Type mismatch

		    [:age]
		      Expected: Integer
		      Actual (String): "42"
	MSG

	object_keys_map = _Map(**{ 1 => Integer, "2" => String, :symbol => _Nilable(Symbol) })

	assert_equal object_keys_map.inspect, "_Map(#{{ 1 => Integer, '2' => String, :symbol => _Nilable(Symbol) }.inspect})"
	assert object_keys_map === { 1 => 2, "2" => "string" }
	assert object_keys_map === { 1 => 2, "2" => "string", :symbol => :foo }

	refute object_keys_map === {}
	refute object_keys_map === { 1 => 2 }

	expect_type_error(expected: object_keys_map, actual: { 1 => "1" }, message: <<~MSG)
		Type mismatch

		    [1]
		      Expected: Integer
		      Actual (String): "1"
		    ["2"]
		      Expected: String
		      Actual (NilClass): nil
	MSG
end

test "_Never" do
	Fixtures::Objects.each do |object|
		refute _Never === object
	end

	refute _Never === nil
end

test "_Nilable" do
	type = _Nilable(String)

	assert type === "string"
	assert type === nil

	refute type === 42
	refute type === :symbol
	refute type === []

	assert _Nilable(String) >= String
	assert _Nilable(String) >= _Nilable(String)
	assert _Nilable(String) >= nil
	assert _Nilable(Enumerable) >= _Nilable(Array)
	assert _Nilable(Enumerable) >= Array
	refute _Nilable(Enumerable) >= String

	expect_type_error(expected: _Nilable(_Hash(Symbol, Integer)), actual: { 1 => 2, :a => :b, :d => 2 }, message: <<~MSG)
  Type mismatch

      []
        Expected: Symbol
        Actual (Integer): 1
      [:a]
        Expected: Integer
        Actual (Symbol): :b
		MSG
end

test "_Not" do
	assert _Not(Integer) === "string"
	assert _Not(_Array(Integer)) === [1, "2", 3]
	assert _Array(_Not(Integer)) === ["2"]

	refute _Not(Integer) === 18
	refute _Not(_Array(Integer)) === []
	refute _Not(_Array(Integer)) === [2]
	refute _Array(_Not(Integer)) === [1, "2"]

	assert _Not(Integer) >= _Not(Integer)
	assert _Not(Numeric) >= _Not(Integer)
	assert _Not(Integer) >= _Constraint(_Not(Integer), String)
	assert _Not(Integer) >= _Intersection(_Not(Integer), String)

	refute _Not(Integer) >= _Constraint(Integer, String)
	refute _Not(Integer) >= _Intersection(Integer, String)

	expect_type_error(expected: _Not(Integer), actual: 18, message: <<~MSG)
		Type mismatch

		  Expected: _Not(Integer)
		  Actual (Integer): 18
	MSG
	# TODO: can we distribute out the _Not over container types?
	expect_type_error(expected: _Not(_Array(Integer)), actual: [18], message: <<~MSG)
		Type mismatch

		  Expected: _Not(_Array(Integer))
		  Actual (Array): [18]
	MSG
	expect_type_error(expected: _Array(_Not(Integer)), actual: [18, "2"], message: <<~MSG)
		Type mismatch

		    [0]
		      Expected: _Not(Integer)
		      Actual (Integer): 18
	MSG
end

test "_Procable" do
	assert _Procable === proc {}
	assert _Procable === -> {}
	assert _Procable === method(:puts)

	refute _Procable === "string"
	refute _Procable === 42
	refute _Procable === nil
end

test "_Range" do
	assert _Range(Integer) === (1..10)
	assert _Range(Float) === (1.0..10.0)
	assert _Range(String) === ("a".."z")

	refute _Range(Integer) === (1.0..10.0)

	assert _Range(Numeric) >= _Range(Integer)
	assert _Range(Integer) >= _Range(Integer)
	refute _Range(Integer) >= _Range(Float)
	assert _Range(String) >= _Range(String)
	refute _Range(String) >= nil

	expect_type_error(expected: _Range(Integer), actual: (1.0..10.0), message: <<~MSG)
		Type mismatch

		  Expected: _Range(Integer)
		  Actual (Range): 1.0..10.0
	MSG
end

test "_Set" do
	assert _Set(String) === Set["a", "b", "c"]
	assert _Set(Integer) === Set[1, 2, 3]

	refute _Set(String) === Set[1, "a", :symbol]
	refute _Set(Integer) === Set["a", "b", "c"]
	refute _Set(String) === ["a", "b", "c"]

	assert _Set(String) >= _Set(String)
	refute _Set(String) >= _Set(Integer)
	assert _Set(Numeric) >= _Set(Integer)
	refute _Set(Numeric) >= Numeric

	expect_type_error(expected: _Set(String), actual: Set["1", 2, "3", nil], message: <<~MSG)
		Type mismatch

		    []
		      Expected: String
		      Actual (Integer): 2
		    []
		      Expected: String
		      Actual (NilClass): nil
	MSG
end

test "_String" do
	assert _String(_Interface(:to_s)) === "string"
	assert _String(size: 6) === "string"

	refute _String(_Interface(:non_existing_method)) === "string"
	refute _String(size: 5) === "string"
end

test "_Symbol" do
	assert _Symbol(_Interface(:to_sym)) === :symbol
	assert _Symbol(size: 6) === :symbol

	refute _Symbol(_Interface(:non_existing_method)) === :symbol
	refute _Symbol(size: 5) === :symbol
end

test "_Time" do
	current_time = Time.now

	assert _Time (_Interface(:to_time)) === current_time
	assert _Time(current_time) === current_time
	assert _Time(current_time..) === current_time + 60

	refute _Time(_Interface(:non_existing_method)) === current_time
	refute _Time(current_time..) === current_time - 60

	unless RUBY_ENGINE == "jruby"
		assert _Time(zone: "UTC") === Time.new(2025, 1, 13, 20, 0, 0, "UTC")
	end

	fifteen_mins_ago = proc { |t| ((Time.now - (60 * 15))..(Time.now)) === t }
	assert _Time(fifteen_mins_ago) === Time.now - (60 * 10)
	refute _Time(fifteen_mins_ago) === Time.now - (60 * 20)
	occurs_on_monday = proc(&:monday?)
	assert _Time(occurs_on_monday) === Time.new(2025, 1, 13)
	refute _Time(occurs_on_monday) === Time.new(2025, 1, 14)

	refute _Time(Time.new(2025, 1, 13, 20, 0, 0, "UTC")) === "2025-01-13 20:00:00 UTC"
	refute _Time(Time.new(2025, 1, 13, 20, 0, 0, "UTC")) === nil
end

test "_Truthy" do
	truthy_objects = Fixtures::Objects - Set[false, nil]
	falsy_objects = Set[false, nil]

	truthy_objects.each do |object|
		assert _Truthy === object
	end

	falsy_objects.each do |object|
		refute _Truthy === object
	end

	assert _Truthy >= true
	assert _Truthy >= _Truthy
	refute _Truthy >= false
	refute _Truthy >= _Not(true)
	refute _Truthy >= _Not(_Truthy)
	assert _Truthy >= _Not(_Not(true))
	assert _Truthy >= _Not(_Not(_Truthy))
end

test "_Tuple" do
	assert _Tuple(String, Integer) === ["a", 1]
	assert _Tuple(Symbol, Float) === [:symbol, 3.14]

	refute _Tuple(String, Integer) === [1, "a"]
	refute _Tuple(String, Integer) === ["a", 1, 2]
	refute _Tuple(String, Integer) === ["a"]
	refute _Tuple(String, Integer) === nil

	assert _Tuple(String, Integer) >= _Tuple(String, Integer)
	refute _Tuple(String, Integer) >= _Tuple(String, Float)
	refute _Tuple(String, Integer) >= [String, Float]

	expect_type_error(expected: _Tuple(String, Integer), actual: [1, "a"], message: <<~ERROR)
		Type mismatch

		    [0]
		      Expected: String
		      Actual (Integer): 1
		    [1]
		      Expected: Integer
		      Actual (String): "a"
	ERROR

	expect_type_error(expected: _Tuple(String, Integer), actual: ["a", 1, 2], message: <<~ERROR)
		Type mismatch

		    [2]
		      Expected: _Never
		      Actual (Integer): 2
	ERROR

	expect_type_error(expected: _Tuple(String, Integer), actual: ["a"], message: <<~ERROR)
  Type mismatch

      [1]
        Expected: Integer
        Actual (NilClass): nil
	ERROR
end

test "_Union matching" do
	type = _Union(String, Integer)

	assert type === "string"
	assert type === 42

	refute type === :symbol
	refute type === []
	refute type === nil

	assert _Union(String, Integer) >= _Union(String, Integer)
	refute _Union(String, Integer) >= _Union(String, Float)
	assert _Union(String, Integer) >= String
	refute _Union(String, Integer) >= Numeric
	assert _Union(String, Numeric) >= Float

	expect_type_error(expected: type, actual: :symbol, message: <<~ERROR)
		Type mismatch

		  Expected: _Union([String, Integer])
		  Actual (Symbol): :symbol
	ERROR

	expect_type_error(expected: _Union(_Array(String), _Array(Integer)), actual: [nil], message: <<~ERROR)
		Type mismatch

		    _Array(String)
		      [0]
		        Expected: String
		        Actual (NilClass): nil
		    _Array(Integer)
		      [0]
		        Expected: Integer
		        Actual (NilClass): nil
	ERROR
end

test "_Union flattens types" do
	type = _Union(
		_Union(String, Integer),
		_Union(Symbol, Float),
	)

	assert_equal type.inspect, "_Union([String, Integer, Symbol, Float])"
end

test "_Union with primitives" do
	position = _Union(:top, :right, :bottom, :left, Integer)

	assert position === :top
	assert position === :right
	assert position === :bottom
	assert position === :left
	assert position === 42

	refute position === :center
	refute position === "top"
end

test "_Void" do
	Fixtures::Objects.each do |object|
		assert _Void === object
	end

	assert _Void >= nil
	assert _Void >= Object
end
