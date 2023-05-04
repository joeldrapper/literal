# frozen_string_literal: true

class Literal::Struct
	extend Literal::Types
	include Literal::Initializer

	def initialize(...)
		@attributes = {}
		super
	end

	def self.__attributes__
		return @__attributes__ if defined?(@__attributes__)

		@__attributes__ = superclass.is_a?(self) ? superclass.__attributes__.dup : []
	end

	def self.attribute(name, type, writer: :private)
		__attributes__ << name

		writer_name = :"#{name}="

		define_method writer_name do |value|
			raise Literal::TypeError, "Expected #{name}: `#{value.inspect}` to be: `#{type.inspect}`." unless type === value

			@attributes[name] = value
		end

		define_method name do
			@attributes[name]
		end

		name
	end

	def to_h
		@attributes.dup
	end
end
