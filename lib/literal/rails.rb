# frozen_string_literal: true

require_relative "../literal"
require_relative "rails/patches/active_record"

module Literal::Rails
	autoload :EnumType, "literal/rails/enum_type"
	autoload :EnumSerializer, "literal/rails/enum_serializer"
end
