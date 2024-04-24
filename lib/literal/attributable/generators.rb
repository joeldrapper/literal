# frozen_string_literal: true

module Literal::Attributable::Generators
	autoload :Base, "literal/attributable/generators/base"
	autoload :Initializer, "literal/attributable/generators/initializer"
	autoload :StructInitializer, "literal/attributable/generators/struct_initializer"
	autoload :StructReader, "literal/attributable/generators/struct_reader"
	autoload :Reader, "literal/attributable/generators/reader"
	autoload :StructWriter, "literal/attributable/generators/struct_writer"
	autoload :Writer, "literal/attributable/generators/writer"
	autoload :DataInitializer, "literal/attributable/generators/data_initializer"
end
