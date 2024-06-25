# frozen_string_literal: true

class Literal::Enum
	extend Literal::Properties

	class << self
		include Enumerable

		attr_reader :members

		def values = @values.keys

		def prop(name, type, kind = :keyword, reader: :public, default: nil)
			super(name, type, kind, reader:, writer: false, default:)
		end

		def inherited(subclass)
			subclass.instance_exec do
				@values = {}
				@members = Set[]
				@indexes = {}
				@index = {}
			end
		end

		def index(name, type, unique: true, &block)
			@indexes[name] = [type, unique, block || name.to_proc]
		end

		def where(**kwargs)
			unless kwargs.length == 1
				raise ArgumentError.new("You can only specify one index when using `where`.")
			end

			key, value = kwargs.first

			unless (type = @indexes.fetch(key)[0]) === value
				raise Literal::TypeError.expected(value, to_be_a: type)
			end

			@index.fetch(key)[value]
		end

		def find_by(**kwargs)
			unless kwargs.length == 1
				raise ArgumentError.new("You can only specify one index when using `where`.")
			end

			key, value = kwargs.first

			unless @indexes.fetch(key)[1]
				raise ArgumentError.new("You can only use `find_by` on unique indexes.")
			end

			unless (type = @indexes.fetch(key)[0]) === value
				raise Literal::TypeError.expected(value, to_be_a: type)
			end

			@index.fetch(key)[value]&.first
		end

		def _load(data)
			self[Marshal.load(data)]
		end

		def const_added(name)
			raise ArgumentError if frozen?
			object = const_get(name)

			if self === object
				object.instance_variable_set(:@name, name)
				@values[object.value] = object
				@members << object
				define_method("#{name.to_s.gsub(/([^A-Z])([A-Z]+)/, '\1_\2').downcase}?") { self == object }
				object.freeze
			end
		end

		def new(*, **, &block)
			raise ArgumentError if frozen?
			new_object = super(*, **, &nil)

			if block
				new_object.instance_exec(&block)
			end

			new_object
		end

		def __after_defined__
			raise ArgumentError if frozen?

			@indexes.each do |name, (type, unique, block)|
				index = @members.group_by(&block).freeze

				index.each do |key, values|
					unless type === key
						raise Literal::TypeError.expected(key, to_be_a: type)
					end

					if unique && values.size > 1
						raise ArgumentError.new("The index #{name} is not unique.")
					end
				end

				@index[name] = index
			end

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

		def fetch(...)
			@values.fetch(...)
		end

		def to_proc
			method(:cast).to_proc
		end
	end

	def initialize(name, value, &block)
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

	def deconstruct
		[value]
	end

	def deconstruct_keys(keys)
		h = to_h
		keys ? h.slice(*keys) : h
	end

	def _dump(level)
		Marshal.dump(@value)
	end
end

TracePoint.trace(:end) do |tp|
	it = tp.self

	if Class === it && it < Literal::Enum
		it.__after_defined__
	end
end
