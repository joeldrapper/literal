# frozen_string_literal: true

class Literal::TypeError < TypeError
	INDENT = "  "

	include Literal::Error

	class Context < Literal::Struct
		prop :receiver, _Nilable(Object)
		prop :method, _Nilable(String)
		prop :label, _Nilable(String)
		prop :expected, _Nilable(_Any)
		prop :actual, _Nilable(_Any)
		prop :children, _Array(Context), default: -> { [] }
		prop :parent, _Nilable(Context)

		def descend(level = 0, &blk)
			yield self, level
			@children.each { |child| child.descend(level + 1, &blk) }
			nil
		end

		def nest(label, expected:, actual:, receiver: nil, method: nil)
			self.expected = expected
			self.actual = actual
			self.label = label
			self.receiver = receiver
			self.method = method
			c = self.class.new
			raise "Cannot nest, already has a parent" if parent
			self.parent = c
			c.children << self
			c
		end

		def root = parent&.root || self

		def self.from_block(expected:, actual:, &)
			leaf = new
			leaf.expected = expected
			leaf.actual = actual
			yield leaf
			raise leaf.inspect unless leaf.children.empty?
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
