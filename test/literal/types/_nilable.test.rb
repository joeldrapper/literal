# frozen_string_literal: true

include Literal::Types

test "#inspect" do
	expect(_Nilable(String).inspect) == "_Nilable(String)"
	expect(_Nilable(Integer).inspect) == "_Nilable(Integer)"
end

test "#===" do
	assert _Nilable(String) === nil
	assert _Nilable(String) === "hello"

	refute _Nilable(String) === 123
	refute _Nilable(String) === true
end

test "#==" do
	assert _Nilable(String) == _Nilable(String)
	assert _Nilable(Integer).eql?(_Nilable(Integer))
	assert _Nilable(Integer) == _Nilable(Integer)
	assert _Nilable(nil) == _Nilable(nil)

	refute _Nilable(String) == _Nilable(Integer)
	refute _Nilable(String) == String
	refute _Nilable(String) == nil
	refute _Nilable(String) == Object.new
end

test "#eql?" do
	assert _Nilable(String).eql? _Nilable(String)
	assert _Nilable(Integer).eql? _Nilable(Integer)

	refute _Nilable(String).eql? _Nilable(Integer)
	refute _Nilable(String).eql? String
end
