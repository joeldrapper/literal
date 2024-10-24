# frozen_string_literal: true

require "dry-initializer"
require "dry-types"
require "dry-struct"

module Types
  include Dry.Types()
end

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
  extend Literal::Properties

  prop :first_name, String
  prop :last_name, String
  prop :age, Integer
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
