# frozen_string_literal: true

require_relative "literal/version"

module Literal
  Loader = Zeitwerk::Loader.for_gem.tap(&:setup)

  module Error; end

  class TypeError < ::TypeError
    include Error
  end

  class ArgumentError < ::ArgumentError
    include Error
  end
end
