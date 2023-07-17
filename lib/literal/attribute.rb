# frozen_string_literal: true

class Literal::Attribute
	RUBY_KEYWORDS = %i[alias and begin break case class def do else elsif end ensure false for if in module next nil not or redo rescue retry return self super then true undef unless until when while yield].to_h { |k| [k, "___#{k}___"] }.freeze

	def initialize(name:, type:, special:, reader:, writer:, positional:, default:, coercion:)
		@name = name
		@type = type
		@special = special
		@reader = reader
		@writer = writer
		@positional = positional
		@default = default
		@coercion = coercion
	end

	attr_reader :name, :type, :special, :reader, :writer, :positional, :default, :coercion

	def reader?
		!!@reader
	end

	def writer?
		!!@writer
	end

	def default?
		nil != @default
	end

	def positional?
		!!@positional
	end

	def coercion?
		!!@coercion
	end

	def coerce(value, context:)
		context.instance_exec(value, &@coercion)
	end

	def escape?
		!!RUBY_KEYWORDS[@name]
	end

	def escaped
		RUBY_KEYWORDS[@name] || @name
	end

	def default_value
		case @default
			when Proc then @default.call
			else @default
		end
	end
end
