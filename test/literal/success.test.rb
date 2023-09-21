# frozen_string_literal: true

# result = Literal::Result(String) { "Hello" }

# describe "#map" do
# 	test "with a block that maps to the expected type" do
# 		final_result = result.map(Integer, &:length)

# 		expect(final_result).to_be_a Literal::Success
# 		expect(final_result.value) == 5
# 	end

# 	test "with a block that doesn't map to the expected type" do
# 		expect(result.map(String, &:length)).to_be_a Literal::Failure
# 	end

# 	test "without an expected type" do
# 		expect { result.map(&:length) }.to_raise ArgumentError
# 	end

# 	test "without a block" do
# 		expect { result.map(String) }.to_raise ArgumentError
# 	end
# end

# describe "#map_failure" do
# 	test "it doesn't yield the block" do
# 		expect { result.map_failure { raise } }.not_to_raise
# 	end

# 	test "it requires a block" do
# 		expect { result.map_failure }.to_raise ArgumentError
# 	end
# end
