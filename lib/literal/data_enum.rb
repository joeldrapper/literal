# frozen_string_literal: true

class Literal::DataEnum < Literal::Data
	include Literal::ModuleDefined

	Index = Data.define(:name, :type, :unique, :block)

	@index_definitions = {}

	class << self
		include Enumerable

		def inherited(subclass)
			index_definitions = @index_definitions

			subclass.instance_exec do
				@members = {}
				@index_definitions = index_definitions.dup
				@indexes = {}
			end

			super
		end

		def define(...)
			definition = new(...)
			@members[definition.to_h] = new(...)
			definition
		end

		def _load(data)
			data = Marshal.load(data)

			self[data[1]] || allocate.tap do |instance|
				instance.instance_exec do
					@attributes = data[1]
					freeze
				end
			end
		end

		def new(...)
			raise ArgumentError if frozen?

			super
		end

		def index(name, type, unique: true, &block)
			@index_definitions[name] = Index.new(name:, type:, unique:, block: block || name.to_proc)
		end

		def each(&)
			@members.each_value(&)
		end

		def sample
			@members.values.sample
		end

		def where(**kwargs)
			unless kwargs.length == 1
				raise ArgumentError, "You can only specify one index when using `where`."
			end

			key, value = kwargs.first

			unless @index_definitions.fetch(key).type === value
				raise Literal::TypeError.expected(value, to_be_a: @index_definitions.fetch(key).type)
			end

			@indexes.fetch(key)[value]
		end

		def find_by(**kwargs)
			unless kwargs.length == 1
				raise ArgumentError, "You can only specify one index when using `where`."
			end

			key, value = kwargs.first

			unless @index_definitions.fetch(key).unique
				raise ArgumentError, "You can only use `find_by` on unique indexes."
			end

			unless @index_definitions.fetch(key).type === value
				raise Literal::TypeError.expected(value, to_be_a: @index_definitions.fetch(key).type)
			end

			@indexes.fetch(key)[value]&.first
		end

		def after_defined
			raise ArgumentError if frozen?

			build_indexes
			@members.freeze
			freeze
		end

		private def build_indexes
			@index_definitions.each_value do |definition|
				index = @members.values.group_by(&definition.block).freeze

				index.each do |key, values|
					unless definition.type === key
						raise Literal::TypeError.expected(key, to_be_a: definition.type)
					end

					if definition.unique && values.size > 1
						raise ArgumentError, "The index #{definition.name} is not unique."
					end
				end

				@indexes[definition.name] = index
			end
		end

		def [](key)
			@members[key]
		end

		def size
			@members.size
		end
	end
end
