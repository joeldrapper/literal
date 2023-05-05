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

class NormalClass
	def initialize(first_name:, last_name:, age:)
		@first_name = first_name
		@last_name = last_name
		@age = age
	end
end

class DryClass
	extend Dry::Initializer

	option :first_name, Types::Strict::String
	option :last_name, Types::Strict::String
	option :age, Types::Strict::Integer
end

class LiteralClass
	extend Literal::Attributes

	attribute :first_name, String
	attribute :last_name, String
	attribute :age, Integer
end

NormalStruct = Struct.new(:first_name, :last_name, :age, keyword_init: true)

class DryStruct < Dry::Struct
	attribute :first_name, Types::Strict::String
	attribute :last_name, Types::Strict::String
	attribute :age, Types::Strict::Integer
end

class LiteralStruct < Literal::Struct
	attribute :first_name, String
	attribute :last_name, String
	attribute :age, Integer
end

NormalData = Data.define(:first_name, :last_name, :age)

class DryValue < Dry::Struct::Value
	attribute :first_name, Types::Strict::String
	attribute :last_name, Types::Strict::String
	attribute :age, Types::Strict::Integer
end

class LiteralData < Literal::Data
	attribute :first_name, String
	attribute :last_name, String
	attribute :age, Integer
end

Benchmark.ips do |x|
	x.report "Ruby Class" do
		NormalClass.new(first_name: "Joel", last_name: "Drapper", age: 29)
	end

	x.report "Dry::Initializer" do
		DryClass.new(first_name: "Joel", last_name: "Drapper", age: 29)
	end

	x.report "Literal::Attributes" do
		LiteralClass.new(first_name: "Joel", last_name: "Drapper", age: 29)
	end

	x.report "Ruby Struct" do
		NormalStruct.new(first_name: "Joel", last_name: "Drapper", age: 29)
	end

	x.report "Dry::Struct" do
		DryStruct.new(first_name: "Joel", last_name: "Drapper", age: 29)
	end

	x.report "Literal::Struct" do
		LiteralStruct.new(first_name: "Joel", last_name: "Drapper", age: 29)
	end


	x.report "Ruby Data" do
		NormalData.new(first_name: "Joel", last_name: "Drapper", age: 29)
	end

	x.report "Dry::Struct::Value" do
		DryValue.new(first_name: "Joel", last_name: "Drapper", age: 29)
	end

	x.report "Literal::Data" do
		LiteralData.new(first_name: "Joel", last_name: "Drapper", age: 29)
	end

	# x.compare!
end
