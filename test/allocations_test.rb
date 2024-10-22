#!/usr/bin/env ruby
# frozen_string_literal: true

# NOTE: This is not a quickdraw test becuase it needs to be run in a single thread.

require "literal"
include Literal::Types

def count_allocations
	x = GC.stat(:total_allocated_objects)
	yield
	GC.stat(:total_allocated_objects) - x
end

def count_warm_allocations(&)
	count_allocations(&)
	count_allocations(&)
end

def no_allocations(type, thing)
	count_warm_allocations do
		type === thing
	end => 0
end

no_allocations(_Any, "anything")
no_allocations(_Any, false)

no_allocations(_Array(String), [])
no_allocations(_Array(String), ["a", "b"])
no_allocations(_Array(String), ["a", "b", 1])

no_allocations(_Boolean, true)
no_allocations(_Boolean, false)
no_allocations(_Boolean, nil)
no_allocations(_Boolean, 1)
