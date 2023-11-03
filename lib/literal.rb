# frozen_string_literal: true

require "zeitwerk"
require "async"
require "concurrent-ruby"

module Literal
	TRACING = ENV["LITERAL_TRACING"] != "false"
	TYPE_CHECKS = ENV["LITERAL_TYPE_CHECKS"] != "false"
	EXPENSIVE_TYPE_CHECKS = ENV["LITERAL_EXPENSIVE_TYPE_CHECKS"] != "false"

	Loader = Zeitwerk::Loader.for_gem.tap do |loader|
		loader.inflector.inflect(
			"lru" => "LRU",
			"lru_type" => "LRUType",
			"json_data_type" => "JSONDataType"
		)
		loader.setup
	end

	extend Literal::Types
	extend Literal::Constructors
end
