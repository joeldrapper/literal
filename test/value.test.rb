# frozen_string_literal: true

UserID = Literal::Value(Integer)
Age = Literal::Value(Integer, 18..)
Name = Literal::Value(String) do
	delegate :length
end

test do
	user_id = UserID.new(123)
	assert_equal(123, user_id.to_i)

	assert_raises Literal::TypeError do
		Age.new(17)
	end

	name = Name.new("Joel")
	assert_equal 4, name.length
end
