# frozen_string_literal: true

UserID = Literal::Brand(String)

test "branded strings" do
	user_id = UserID.new("123")

	assert UserID === user_id
	assert_equal "123", user_id

	refute UserID === "123"
end

test "prevent interned types" do
	assert_raises ArgumentError do
		Literal::Brand(Integer)
	end

	assert_raises ArgumentError do
		Literal::Brand(true)
	end

	assert_raises ArgumentError do
		Literal::Brand(false)
	end

	assert_raises ArgumentError do
		Literal::Brand(Literal::Types._Boolean)
	end

	assert_raises ArgumentError do
		Literal::Brand(nil)
	end

	assert_raises ArgumentError do
		Literal::Brand(Symbol)
	end

	assert_raises ArgumentError do
		Literal::Brand(1)
	end

	assert_raises ArgumentError do
		Literal::Brand(:two)
	end
end
