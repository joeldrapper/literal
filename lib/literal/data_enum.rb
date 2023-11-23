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
				@data = []
				@index_definitions = index_definitions.dup
				@indexes = {}
			end

			super
		end

		def define(...)
			definition = new(...)
			@data << new(...)
			definition
		end

		def new(...)
			raise ArgumentError if frozen?

			super
		end

		def allocate(...)
			raise ArgumentError if frozen?

			super
		end

		def index(name, type, unique: false, &block)
			@index_definitions[name] = Index.new(name:, type:, unique:, block: block || name.to_proc)
		end

		def each(&)
			@data.each(&)
		end

		def sample
			@data.sample
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
			@data.freeze
			freeze
		end

		private def build_indexes
			@index_definitions.each_value do |definition|
				index = @data.group_by(&definition.block).freeze

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

		def [](index)
			@data[index]
		end

		def size
			@data.size
		end
	end
end
