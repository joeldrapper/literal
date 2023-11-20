# frozen_string_literal: true

class Literal::Enum
	include Literal::ModuleDefined

	class << self
		include Enumerable

		attr_reader :type, :members

		def values = @values.keys

		def respond_to_missing?(name, include_private = false)
			return super if frozen?
			return super unless Symbol === name
			return super unless ("A".."Z").include? name[0]

			true
		end

		def inherited(subclass)
			subclass.instance_exec do
				@values = {}
				@members = []
			end
		end

		def _load(data)
			self[Marshal.load(data)]
		end

		def method_missing(name, value, *args, **kwargs, &)
			return super if frozen?
			return super unless name.is_a?(Symbol)
			return super unless name[0] == name[0].upcase

			raise ArgumentError if args.length > 0
			raise ArgumentError if kwargs.length > 0
			raise ArgumentError if @values.key? value
			raise ArgumentError if constants.include?(name)

			value = value.dup.freeze unless value.frozen?

			member = new(name, value, &)
			const_set name, member
			@values[value] = member
			@members << member

			define_method("#{name.to_s.gsub(/([^A-Z])([A-Z]+)/, '\1_\2').downcase}?") { self == member }
		end

		def index(name, &block)
			raise ArgumentError unless Symbol === name
			raise ArgumentError if frozen?

			@index_definitions ||= {}
			@index_definitions[name] = block || name.to_proc
		end

		def where(**kwargs)
			unless kwargs.length == 1
				raise ArgumentError, "You can only specify one index when using `where`."
			end

			key, value = kwargs.first

			@indexes.fetch(key)[value]
		end

		def after_defined
			raise ArgumentError if frozen?

			@indexes = {}

			@index_definitions&.each do |name, block|
				@indexes[name] = @members.group_by(&block).freeze
			end

			@index_definitions.freeze
			@indexes.freeze

			@values.freeze
			@members.freeze
			freeze
		end

		def each(&)
			@members.each(&)
		end

		def each_value(&)
			@values.each_key(&)
		end

		def [](value)
			@values[value]
		end

		alias_method :cast, :[]

		def to_proc
			method(:cast).to_proc
		end
	end

	def initialize(name, value, &block)
		unless type === value
			raise Literal::TypeError.expected(value, to_be_a: type)
		end

		@name = name
		@value = value
		instance_exec(&block) if block
		freeze
	end

	attr_reader :value

	def name
		"#{self.class.name}::#{@name}"
	end

	alias_method :inspect, :name

	def siblings
		self.class.members
	end

	def _dump(level)
		Marshal.dump(@value)
	end

	def call(&block)
		if block
			Literal::Case.new(*siblings, &block).call(self)
		else
			self
		end
	end

	alias_method :handle, :call

	def to_proc
		method(:call).to_proc
	end
end
