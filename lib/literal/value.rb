class Literal::Value
	class << self
		attr_reader :__type__

		def define(type, &block)
			value_class = Class.new(self) do
				@__type__ = type

				case type
				when Literal::Types::_Class(String)
					alias_method :to_s, :value
					alias_method :to_str, :value
				when Literal::Types::_Class(Symbol)
					alias_method :to_sym, :value
				when Literal::Types::_Class(Integer)
					alias_method :to_i, :value
				when Literal::Types::_Class(Float)
					alias_method :to_f, :value
				when Literal::Types::_Class(Set)
					alias_method :to_set, :value
				when Literal::Types::_Class(Array)
					alias_method :to_a, :value
					alias_method :to_ary, :value
				when Literal::Types::_Class(Hash)
					alias_method :to_h, :value
				when Literal::Types::_Class(Proc)
					alias_method :to_proc, :value
				end
			end

			value_class.class_exec(&block) if block
			value_class
		end
	end

	def initialize(value)
		type = self.class.__type__
		raise Literal::TypeError, "Expected value: `#{value.inspect}` to be: `#{type.inspect}`." unless type === value
		@value = value.frozen? ? value : value.dup.freeze
		freeze
	end

	attr_reader :value

	def inspect
	  "#{self.class.name}(#{value.inspect})"
  end
end
