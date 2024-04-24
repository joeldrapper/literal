include Literal::Types

test "never matches anything" do
	Fixtures::Objects.each do |object|
		refute NeverType === object
	end

	refute NeverType === nil
end
