#!/usr/bin/env ruby
# frozen_string_literal: true

require "literal"
require "benchmark/ips"
require "dry-initializer"
require "dry-types"

module Types
	include Dry.Types()
end

puts RUBY_DESCRIPTION

class Person
	extend Literal::Attributes

	attribute :first_name, String
	attribute :last_name, String
	attribute :age, Integer
end

class DryPerson
	extend Dry::Initializer

	option :first_name, type: Types::Strict::String
	option :last_name, type: Types::Strict::String
	option :age, type: Types::Strict::Integer
end

Benchmark.ips do |x|
	x.report "Literal definition" do
		Class.new do
			extend Literal::Attributes

			attribute :first_name, String
			attribute :last_name, String
			attribute :age, Integer
		end
	end

	x.report "Dry definition" do
		Class.new do
			extend Dry::Initializer

			option :first_name, type: Types::Strict::String
			option :last_name, type: Types::Strict::String
			option :age, type: Types::Strict::Integer
		end
	end

	x.report "Literal init" do
		Person.new(
			first_name: "John",
			last_name: "Doe",
			age: 30
		)
	end

	x.report "Dry init" do
		DryPerson.new(
			first_name: "John",
			last_name: "Doe",
			age: 30
		)
	end
end
