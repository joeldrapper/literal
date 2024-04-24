# frozen_string_literal: true

include Literal::Types

test "===" do
	assert _Procable === -> {}
	assert _Procable === Proc.new {}
	assert _Procable === :a
	assert _Procable === {}
	refute _Procable === _Procable
	refute _Procable === []
	refute _Procable === nil
end

test "== method" do
	assert _Procable == _Procable
	assert _Procable.eql?(_Procable)
	refute _Procable == _Array(String)
	refute _Procable == nil
	refute _Procable == Object.new
end
