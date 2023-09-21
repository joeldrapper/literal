# frozen_string_literal: true

success = Literal::Result(String, RuntimeError, TypeError) do |r|
	r.success("Hello")
end

failure = Literal::Result(String, RuntimeError, TypeError) do |r|
	r.failure(RuntimeError.new("Hello"))
end

test do
	expect(success).to_be_a Literal::Success
	expect(success.value) == "Hello"

	expect(failure).to_be_a Literal::Failure
	expect(failure.value.message) == "Hello"

	output = success.handle do |r|
		r.on_success { "Success" }
		r.on_failure(RuntimeError) { "Failure" }
		r.else { "else" }
	end

	expect(output) == "Success"
end

test "rescue" do
	result = Literal::Result(String, ArgumentError).rescue(ArgumentError) do |r|
		raise ArgumentError, "Hello"
		r.success("Hello")
	end

	expect(result).to_be_a Literal::Failure
end

# include Literal::Monads

# describe "Result(Hash)" do
# 	class CardError < StandardError
# 		def detailed_message(highlight: false, **opt)
# 			"CardError details"
# 		end
# 	end

# 	class ConnectionError < StandardError; end

# 	def test_lift(&block)
# 		fetch_something(block) do |res|
# 			res.on_success do |h|
# 				assert h[:foo] == "bar"
# 			end
# 			res.on_failure(CardError, ConnectionError) do |e|
# 				assert e.message == "Bar"
# 			end
# 			res.on_failure do |e|
# 				assert e.message == "Other"
# 			end
# 		end
# 	end

# 	describe "#lift" do
# 		def fetch_something(result, &)
# 			Literal::Result(Hash, &result).lift(CardError, ConnectionError, &)
# 		end

# 		describe "with #lift" do
# 			test "with success" do
# 				test_lift { { foo: "bar" } }
# 			end

# 			test "with checked failure" do
# 				test_lift { raise CardError, "Bar" }
# 				test_lift { raise ConnectionError, "Bar" }
# 			end

# 			test "with unchecked failure" do
# 				test_lift { raise StandardError, "Other" }
# 			end

# 			test "raises on missing failure case" do
# 				expect do
# 					fetch_something(proc { raise StandardError }) do |res|
# 						res.on_success
# 						res.on_failure(CardError, ConnectionError) {}
# 					end
# 				end.to_raise(ArgumentError)
# 			end
# 		end

# 		describe "with pattern matching" do
# 			def test_lift_pattern_matching(&block)
# 				case fetch_something(block)
# 				in Literal::Success(foo:)
# 					assert foo == "bar"
# 				in Literal::Failure(CardError | ConnectionError => e)
# 					assert e.message == "Bar"
# 				in Literal::Failure(e)
# 					assert e.message == "Other"
# 				end
# 			end

# 			test "with success" do
# 				test_lift_pattern_matching { { foo: "bar" } }
# 			end

# 			test "with checked failure" do
# 				test_lift_pattern_matching { raise CardError, "Bar" }
# 				test_lift_pattern_matching { raise ConnectionError, "Bar" }
# 			end

# 			test "with unchecked failure" do
# 				test_lift_pattern_matching { raise StandardError, "Other" }
# 			end

# 			test "raises on missing failure case" do
# 				expect do
# 					case fetch_something(proc { raise StandardError })
# 					in Literal::Success(foo:)
# 					# success
# 					in Literal::Failure(CardError | ConnectionError => e)
# 						# error
# 					end
# 				end.to_raise(NoMatchingPatternError)
# 			end

# 			test "pattern matching on an exception" do
# 				case fetch_something(proc { raise StandardError, "Hello" })
# 				in Literal::Failure(message: "Hello")
# 					assert true
# 				else
# 					assert false
# 				end
# 			end

# 			test "pattern matching on an custom exception" do
# 				res = fetch_something(proc { raise CardError, "Hello" })
# 				assert((res in Literal::Failure(CardError => e)))
# 				refute((res in Literal::Failure(ConnectionError => e)))
# 				assert((res in Literal::Failure(Exception)))
# 				assert((res in Literal::Failure(message: "Hello")))
# 				refute((res in Literal::Failure(message: "Bye")))
# 				assert((res in Literal::Failure(detailed_message: "CardError details")))
# 				res => Literal::Failure(full_message:)
# 				assert full_message.include?("result.test.rb")

# 				res = Result(String) do
# 					raise StandardError, "Hello"
# 				rescue StandardError => _e
# 					raise CardError, "Hello"
# 				end
# 				assert((res in Literal::Failure(cause: StandardError)))
# 				res => Literal::Failure(backtrace_locations: [line1, *])
# 				assert line1.path.include?("result.test.rb")
# 			end
# 		end
# 	end

# 	describe "#lift!" do
# 		def fetch_something(result, &)
# 			Literal::Result(Hash, &result).lift!(CardError, ConnectionError, &)
# 		end

# 		describe "with #lift!" do
# 			test "with success" do
# 				test_lift { { foo: "bar" } }
# 			end

# 			test "with checked failure" do
# 				test_lift { raise CardError, "Bar" }
# 				test_lift { raise ConnectionError, "Bar" }
# 			end

# 			test "with unchecked failure" do
# 				test_lift { raise StandardError, "Other" }
# 			end

# 			test "raises original error on missing failure case" do
# 				expect do
# 					fetch_something(proc { raise StandardError }) do |res|
# 						res.on_success
# 						res.on_failure(CardError, ConnectionError) {}
# 					end
# 				end.to_raise(StandardError)
# 			end
# 		end
# 	end
# end
