# frozen_string_literal: true

test "ActiveRecord::Relation with non-ActiveRecord::Base child" do
	assert_raises(Literal::TypeError) do
		Class.new do
			extend Literal::Properties
			prop :example, ActiveRecord::Relation(String)
		end
	end
end
