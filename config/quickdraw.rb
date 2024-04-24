# frozen_string_literal: true

require "literal"
require "securerandom"

module Fixtures
	TruthyObjects = [
		SecureRandom.hex,
		SecureRandom.hex.freeze,
		0,
		0.0,
		[],
		[].freeze,
		{},
		{}.freeze,
		true,
		String,
		Integer,
		Float,
		Array,
		SecureRandom
	].freeze

	Objects = [
		*TruthyObjects,
		false
	]
end
