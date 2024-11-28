# frozen_string_literal: true

class Person < Literal::Struct
	prop :name, String
end

class Student < Person
	prop :final_grade, Integer
end

test do
	person = Person.new(name: "Joel")
	expect(person.name) == "Joel"
end

test do
	person = Person.new(name: "Joel")
	person.name = "Jill"
	expect(person.name) == "Jill"
end

test do
	person = Person.new(name: "Joel")
	expect(person.to_h) == { name: "Joel" }
end

test do
	a = Person.new(name: "Joel")
	b = Person.new(name: "Joel")

	expect(a) == b
end

test do
	a = Person.new(name: "Joel")
	b = Person.new(name: "Jill")

	expect(a) != b
end

test do
	a = Person.new(name: "Joel")
	b = Student.new(name: "Joel", final_grade: 90)

	expect(a) != b
end

# Marshal doesn't work with anonymous classes
class ::RootStruct < Literal::Struct
	prop :name, String
end

test "marshalling" do
	a = RootStruct.new(name: "Joel")
	b = Marshal.load(Marshal.dump(a))

	expect(b) == a
end

test "marshalling a frozen struct" do
	a = RootStruct.new(name: "Joel")
	a.freeze

	b = Marshal.load(Marshal.dump(a))

	expect(b) == a
	expect(b).to_be(:frozen?)
end

test "as_pack/from_pack" do
	a = RootStruct.new(name: "Joel")
	a.freeze

	b = RootStruct.from_pack(a.as_pack)

	expect(b) == a
	expect(b).to_be(:frozen?)
end

test "can be deconstructed" do
	person = Person.new(name: "Joel")
	expect(person.deconstruct) == ["Joel"]
end

test "can be deconstructed with keys" do
	person = Person.new(name: "Joel")
	expect(person.deconstruct_keys([:name])) == { name: "Joel" }
	expect(person.deconstruct_keys(nil)) == { name: "Joel" }
end

test "can be indexed" do
	person = Person.new(name: "Joel")
	expect(person[:name]) == "Joel"
end

test "returns nil for unknown keys" do
	person = Person.new(name: "Joel")
	expect { person[:age] }.to_raise(NameError)
	expect(person["name"]) == "Joel"
	expect { person[0] }.to_raise(TypeError)
end

class WithKeywordPropertyNames < Literal::Struct
	prop :begin, String
	prop :end, String
	prop :module, _Nilable(Module)
end

test do
	with_keyword_property_names = WithKeywordPropertyNames.new(begin: "start", end: "finish")
	expect(with_keyword_property_names.to_h) == { :begin => "start", :end => "finish", :module => nil }
	expect(with_keyword_property_names) == with_keyword_property_names
	expect(with_keyword_property_names) == with_keyword_property_names.dup
	expect(with_keyword_property_names.hash) == with_keyword_property_names.dup.hash
	expect(with_keyword_property_names[:begin]) == "start"
	expect(with_keyword_property_names[:end]) == "finish"
	expect(with_keyword_property_names[:module]) == nil
	expect(with_keyword_property_names["begin"]) == "start"
	expect(with_keyword_property_names["end"]) == "finish"
	expect(with_keyword_property_names["module"]) == nil
	expect(with_keyword_property_names.begin) == "start"
	expect(with_keyword_property_names.end) == "finish"
	expect(with_keyword_property_names.module) == nil
	with_keyword_property_names[:begin] = "start2"
	with_keyword_property_names.end = "finish2"
	expect(with_keyword_property_names.to_h) == { :begin => "start2", :end => "finish2", :module => nil }
end
