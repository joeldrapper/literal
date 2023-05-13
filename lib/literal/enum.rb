# frozen_string_literal: true

class Literal::Enum
	include Enumerable

	class << self
		def cast(value)
			@values[value]
		end

		def values
			@values.keys
		end

		def each(&block)
			@members.each(&block)
		end

		def define(type, &block)
			Class.new(self, &block).freeze
		end

		def method_missing(name, *args, **kwargs, &block)
			return super if frozen? || args.length > 1 || kwargs.any?
			return super unless name[0] =~ /[A-Z]/

			new(name, *args, &block)
		end

		def new(name, a = nil, b = nil, &block)
			raise ArgumentError if frozen?

			@values ||= Concurrent::Map.new
			@members ||= Concurrent::Array.new

			if !b && a.is_a?(Proc)
				transitions_to = a
				value = name
			else
				value = a || name
				transitions_to = b
			end

			if self == Literal::Enum
				raise ArgumentError,
					"You can't add values to the abstract Enum class itself."
			end

			if const_defined?(name)
				raise NameError,
					"Name conflict: '#{self.name}::#{name}' is already defined."
			end

			if @values[value]
				raise NameError,
					"Value conflict: the value '#{value}' is defined for '#{cast(value).name}'."
			end

			class_eval(<<-RUBY, __FILE__, __LINE__ + 1)
        def #{name.to_s.gsub(/([a-z])([A-Z])/, '\1_\2').downcase!}?
          @short_name == "#{name.to_s.gsub(/([a-z])([A-Z])/, '\1_\2').downcase!}"
        end
			RUBY

			member = super(name, value)
			member.define_singleton_method(:transitions_to, transitions_to) if transitions_to
			member.instance_eval(&block) if block_given?
			member.freeze

			const_set(name, member)
			@members << member
			@values[value] = member

			member
		end
	end

	def initialize(name, value)
		@name = "#{self.class.name}::#{name}"
		@value = value
		@short_name = name.to_s.gsub(/([a-z])([A-Z])/, '\1_\2').downcase!
	end

	attr_accessor :name, :value, :short_name
end
