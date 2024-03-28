# frozen_string_literal: true

require_relative "../test/support/helper"

require "simplecov"

module ToChange
  def to_change(from:, to:)
    original = block.call
    yield
    changed = block.call

    assert(from === original) { "Expected `#{original.inspect}` to == `#{from.inspect}`." }
    assert(to === changed) { "Expected `#{changed.inspect}` to == `#{to.inspect}`." }
  end
end

Quickdraw.configure do |config|
  config.matcher ToChange, Hash
end

SimpleCov.start do
  command_name "Tests"
  enable_coverage :branch
  enable_coverage_for_eval

  add_group "Types", "lib/literal/types"
end
