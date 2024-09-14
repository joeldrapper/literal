# frozen_string_literal: true

class Literal::TypeError < TypeError
	INDENT = "  "

	include Literal::Error

	class Context
		attr_accessor :receiver, :method, :label, :expected, :actual, :children, :parent

		def initialize(
			receiver: nil, # _Nilable(Object)
			method: nil, # _Nilable(String)
			label: nil, # _Nilable(String)
			expected: nil, # _Nilable(_Any)
			actual: nil, # _Nilable(_Any)
			parent: nil # _Nilable(Context)
		)
			@receiver = receiver
			@method = method
			@label = label
			@expected = expected
			@actual = actual
			@children = []
			@parent = parent
		end

		def descend(level = 0, &blk)
			yield self, level
			@children.each { |child| child.descend(level + 1, &blk) }
			nil
		end

		def nest(label, expected:, actual:, receiver: nil, method: nil)
			raise ArgumentError.new("Cannot nest, already has a parent") if parent

			@expected = expected
			@actual = actual
			@label = label
			@receiver = receiver
			@method = method
			c = self.class.new
			self.parent = c
			c.children << self
			c
		end

		def root = parent&.root || self

		def self.from_block(expected:, actual:)
			leaf = new(expected:, actual:)
			yield leaf
			raise "Expected leaf to have no children, instead is #{leaf.inspect}" unless leaf.children.empty?
			leaf.root
		end
	end

	def initialize(expected:, actual:, &)
		@context = Context.from_block(expected:, actual:, &)

		super()
	end

	def message
		message = +"Type mismatch\n\n"

		@context.descend do |c, level|
			idt = INDENT * level
			if c.receiver || c.method
				message << idt
				message << c.receiver.class.inspect if c.receiver
				message << c.method if c.method
				message << " (from #{backtrace[1]})" if level.zero?
				message << "\n"
			end
			if c.label
				idt << INDENT
				message << idt << c.label
				# message << " #{c.expected.inspect}" if c.expected && !c.children.empty?
				message << "\n"
			end
			if c.expected && c.children.empty?
				message << idt << "  Expected: #{c.expected.inspect}\n"
				message << idt << "  Actual (#{c.actual.class}): #{c.actual.inspect}\n"
			end
		end
		message
	end

	def deconstruct_keys(keys)
		to_h.slice(*keys)
	end

	def to_h
		@context.to_h
	end
end
