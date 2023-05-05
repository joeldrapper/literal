#!/usr/bin/env ruby
# frozen_string_literal: true

require "literal"
require "benchmark/ips"
require "dry-initializer"
require "dry-types"
require "dry-struct"

module Types
	include Dry.Types()
end

puts RUBY_DESCRIPTION

class LiteralStruct < Literal::Struct
	attribute :first_name, String
	attribute :last_name, String
	attribute :age, Integer
end

class DryStruct < Dry::Struct
	attribute :first_name, Types::Strict::String
	attribute :last_name, Types::Strict::String
	attribute :age, Types::Strict::Integer
end

class LiteralData < Literal::Data
	attribute :first_name, String
	attribute :last_name, String
	attribute :age, Integer
end

class DryValue < Dry::Struct::Value
	attribute :first_name, Types::Strict::String
	attribute :last_name, Types::Strict::String
	attribute :age, Types::Strict::Integer
end

Benchmark.ips do |x|
	x.report "Literal Struct" do
		LiteralStruct.new(first_name: "Joel", last_name: "Drapper", age: 29)
	end

	x.report "Dry Struct" do
		DryStruct.new(first_name: "Joel", last_name: "Drapper", age: 29)
	end

	x.report "Literal Data" do
		LiteralData.new(first_name: "Joel", last_name: "Drapper", age: 29)
	end

	x.report "Dry Value" do
		DryValue.new(first_name: "Joel", last_name: "Drapper", age: 29)
	end
end
