# frozen_string_literal: true

class Literal::Attribute
	RUBY_KEYWORDS = %i[alias and begin break case class def do else elsif end ensure false for if in module next nil not or redo rescue retry return self super then true undef unless until when while yield].to_h { |k| [k, "__#{k}__"] }.freeze

	def initialize(name:, type:, kind:, reader:, writer:, default:, coercion:)
		@name = name
		@type = type
		@kind = kind
		@reader = reader
		@writer = writer
		@default = default
		@coercion = coercion
	end

	attr_reader :name, :type, :kind, :reader, :writer, :default, :coercion

	def coerce(value, context:)
		context.instance_exec(value, &@coercion)
	end

	def ruby_keyword?
		!!RUBY_KEYWORDS[@name]
	end

	def escaped_name
		RUBY_KEYWORDS[@name] || @name
	end

	def default_value
		case @default
			when Proc then @default.call
			else @default
		end
	end
end
