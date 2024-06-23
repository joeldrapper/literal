# frozen_string_literal: true

require_relative "../literal"
require_relative "rails/patches/active_record"

module Literal::Rails
	autoload :EnumType, "literal/rails/enum_type"
	autoload :EnumSerializer, "literal/rails/enum_serializer"

	autoload :StructuredDataType, "literal/rails/structured_data_type"
	autoload :StructuredDataSerializer, "literal/rails/structured_data_serializer"
end
