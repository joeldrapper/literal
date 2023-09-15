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

include Literal::Monads

describe "Result(Hash)" do
	class CardError < StandardError; end
	class ConnectionError < StandardError; end

	def test_lift(&block)
		fetch_something(block) do |res|
			res.success do |h|
				assert h[:foo] == "bar"
			end
			res.failure(CardError, ConnectionError) do |e|
				assert e.message == "Bar"
			end
			res.failure do |e|
				assert e.message == "Other"
			end
		end
	end

	describe "#lift" do
		def fetch_something(result, &)
			Literal::Result(Hash, &result).lift(CardError, ConnectionError, &)
		end

		describe "with #lift" do
			test "with success" do
				test_lift { { foo: "bar" } }
			end

			test "with checked failure" do
				test_lift { raise CardError, "Bar" }
				test_lift { raise ConnectionError, "Bar" }
			end

			test "with unchecked failure" do
				test_lift { raise StandardError, "Other" }
			end

			test "raises on missing failure case" do
				expect do
					fetch_something(proc { raise StandardError }) do |res|
						res.success {}
						res.failure(CardError, ConnectionError) {}
					end
				end.to_raise(ArgumentError)
			end
		end

		describe "with pattern matching" do
			def test_lift_pattern_matching(&block)
				case fetch_something(block)
				in Literal::Success(foo:)
					# if deconstruct_keys was changed to delegate to the value then you could avoid the `success:`
					assert foo == "bar"
				in Literal::Failure(CardError | ConnectionError => e)
					assert e.message == "Bar"
				in Literal::Failure(e)
					assert e.message == "Other"
				end
			end

			test "with success" do
				test_lift_pattern_matching { { foo: "bar" } }
			end

			test "with checked failure" do
				test_lift_pattern_matching { raise CardError, "Bar" }
				test_lift_pattern_matching { raise ConnectionError, "Bar" }
			end

			test "with unchecked failure" do
				test_lift_pattern_matching { raise StandardError, "Other" }
			end

			test "raises on missing failure case" do
				expect do
					case fetch_something(proc { raise StandardError })
					in Literal::Success(success: {foo:})
					# success
					in Literal::Failure(CardError | ConnectionError => e)
						# error
					end
				end.to_raise(NoMatchingPatternError)
			end

			test "pattern matching on an exception" do
				case fetch_something(proc { raise StandardError, "Hello" })
				in Literal::Failure(message: "Hello", detailed_message:)
					assert true
				else
					assert false
				end
			end
		end
	end

	describe "#lift!" do
		def fetch_something(result, &)
			Literal::Result(Hash, &result).lift!(CardError, ConnectionError, &)
		end

		describe "with #lift!" do
			test "with success" do
				test_lift { { foo: "bar" } }
			end

			test "with checked failure" do
				test_lift { raise CardError, "Bar" }
				test_lift { raise ConnectionError, "Bar" }
			end

			test "with unchecked failure" do
				test_lift { raise StandardError, "Other" }
			end

			test "raises original error on missing failure case" do
				expect do
					fetch_something(proc { raise StandardError }) do |res|
						res.success {}
						res.failure(CardError, ConnectionError) {}
					end
				end.to_raise(StandardError)
			end
		end
	end
end
