# frozen_string_literal: true

UserID = Literal::Brand(String)

test "branded strings" do
	user_id = UserID.new("123")

	assert UserID === user_id
	assert_equal "123", user_id
end
