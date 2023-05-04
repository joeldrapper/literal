# frozen_string_literal: true

module Literal::Attributes
	extend Literal::Types

	def attribute(name, type, reader: false, writer: :private)
		__attributes__ << name

		writer_name = :"#{name}="
		ivar_name = :"@#{name}"

		define_method writer_name do |value|
			raise Literal::TypeError, "Expected `#{value.inspect}` to be a `#{type.inspect}`." unless type === value

			instance_variable_set(ivar_name, value)
		end

		private writer_name unless writer == :public

		if reader
			attr_reader name

			private name unless reader == :public
		end

		name
	end

	def __attributes__
		return @__attributes__ if defined?(@__attributes__)

		@__attributes__ = superclass.is_a?(self) ? superclass.__attributes__.dup : []
	end

	def self.extended(base)
		base.include(Literal::Initializer)
	end
end
