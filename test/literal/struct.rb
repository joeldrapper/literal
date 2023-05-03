class Person < Literal::Struct
  attribute :name, String
  attribute :age, Integer
end

test do
  expect {
    Person.new(name: "John", age: 42)
  }.not_to_raise
end

test do
  expect {
    Person.new(name: 1, age: "Hello")
  }.to_raise(Literal::TypeError) do |error|
    expect(error.message) == "Expected name: `1` to be: `String`."
  end
end
