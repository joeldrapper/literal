# frozen_string_literal: true

require "securerandom"

test do
	[0.1, 0.01, 0.001, 0.0001, 0.00001].each do |error_rate|
		samples = 1_000_000

		bf = Literal::BloomFilter.create("foo", "bar", "baz", "bing", "bong", "boo", error_rate:)

		expected_errors = error_rate * samples

		errors = samples.times.select { bf.contains?(SecureRandom.hex) }.size

		assert bf.contains?("foo")
		assert bf.contains?("bar")
		assert bf.contains?("baz")
		assert bf.contains?("bing")
		assert bf.contains?("bong")
		assert bf.contains?("boo")

		assert errors < (expected_errors * 5)
	end
end

test do
	bf = Literal::BloomFilter.create("foo", "bar", "baz", "bing", "bong", "boo", error_rate: 0.01)

	serialized = bf.serialize

	expect(serialized.length) == 24

	deserialized = Literal::BloomFilter.deserialize(serialized)

	assert deserialized.contains?("foo")
	assert deserialized.contains?("bar")
	assert deserialized.contains?("baz")
	assert deserialized.contains?("bing")
	assert deserialized.contains?("bong")
	assert deserialized.contains?("boo")
end
