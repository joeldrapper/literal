# frozen_string_literal: true
# # frozen_string_literal: true

# include Literal::Monads

# describe "Result(String)" do
# 	let def result = Result(String)

# 	let def success = result.new("Foo")

# 	let def failure
# 		result.new(
# 			StandardError.new("Bar")
# 		)
# 	end

# 	describe ".try" do
# 		test "with correct type" do
# 			expect(result.try { "Foo" }).to_be :success?
# 		end

# 		test "with incorrect type" do
# 			expect(result.try { 1 }).to_be :failure?
# 		end

# 		test "with raise" do
# 			expect(result.try { raise }).to_be :failure?
# 		end
# 	end

# 	test "#success?" do
# 		expect(success).to_be :success?
# 		expect(failure).not_to_be :success?
# 	end

# 	test "#failure?" do
# 		expect(failure).to_be :failure?
# 		expect(success).not_to_be :failure?
# 	end

# 	test "#inspect" do
# 		expect(success.inspect) == %(Literal::Success("Foo"))
# 		expect(failure.inspect) == "Literal::Failure(#<StandardError: Bar>)"
# 	end

# 	describe "#handle" do
# 		test "with success" do
# 			result = success.handle do |r|
# 				r.when(Literal::Success) { "Hi" }
# 				r.when(Literal::Failure) { "Bye" }
# 			end

# 			expect(result) == "Hi"
# 		end

# 		test "with failure" do
# 			result = failure.handle do |r|
# 				r.when(Literal::Success) { "Hi" }
# 				r.when(Literal::Failure) { "Bye" }
# 			end

# 			expect(result) == "Bye"
# 		end
# 	end
# end
