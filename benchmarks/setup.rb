# frozen_string_literal: true

require "active_model"
require "dry-initializer"
require "dry-types"
require "dry-struct"
require "ruby-enum"
require "typesafe_enum"
require "literal"

module Types
	include Dry.Types()
end

class NormalClass
	def initialize(first_name:, last_name:, age:)
		@first_name = first_name
		@last_name = last_name
		@age = age
	end

	attr_reader :first_name, :last_name, :age
end

class DryClass
	extend Dry::Initializer

	option :first_name, Types::Strict::String
	option :last_name, Types::Strict::String
	option :age, Types::Strict::Integer
end

class LiteralClass
	extend Literal::Properties

	prop :first_name, String
	prop :last_name, String
	prop :age, Integer
end

class LiteralClassWithReaders
	extend Literal::Properties

	prop :first_name, String, reader: :public
	prop :last_name, String, reader: :public
	prop :age, Integer, reader: :public
end

class ActiveModelAttributesClass
	include ActiveModel::API
	include ActiveModel::Attributes

	attribute :first_name, :string
	attribute :last_name, :string
	attribute :age, :integer
end

NormalStruct = Struct.new(:first_name, :last_name, :age, keyword_init: true)

class DryStruct < Dry::Struct
	attribute :first_name, Types::Strict::String
	attribute :last_name, Types::Strict::String
	attribute :age, Types::Strict::Integer
end

class LiteralStruct < Literal::Struct
	prop :first_name, String
	prop :last_name, String
	prop :age, Integer
end

NormalData = Data.define(:first_name, :last_name, :age)

class LiteralData < Literal::Data
	prop :first_name, String
	prop :last_name, String
	prop :age, Integer
end

class LiteralColor < Literal::Enum(Integer)
	prop :hex, String
	index :hex, String
	index :lower_hex, String, unique: false do |color|
		color.hex.downcase
	end

	Red = new(1, hex: "#FF0000")
	Green = new(2, hex: "#00FF00")
	Blue = new(3, hex: "#0000FF")
end

class RubyEnumColor
	include Ruby::Enum

	define :RED, "#FF0000"
	define :GREEN, "#00FF00"
	define :BLUE, "#0000FF"
end

class TypesafeEnumColor < TypesafeEnum::Base
	new :RED, "#FF0000"
	new :GREEN, "#00FF00"
	new :BLUE, "#0000FF"
end
