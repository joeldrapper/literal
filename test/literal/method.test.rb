# frozen_string_literal: true

def abstract_class
	Class.new do
		extend Literal::Modifiers::Abstract

		abstract def test_1(a, b, c); end
		abstract def test_2(a, *b); end
		abstract def test_3(*a); end
		abstract def test_4(a:, b:); end
		abstract def test_5(a:, **b); end
		abstract def test_6(a:, b: 1); end
		abstract def test_7(a, b = 1); end

		protected abstract def protected_method(a, b); end

		private abstract def private_method(a, b); end
	end
end

def valid_concrete_class
	Class.new do
		def test_1_1(*a); end
		def test_1_2(a, *b); end
		def test_1_3(a, b, *c); end
		def test_1_4(a, b, c); end
		# Its ok to add further optional parameters
		def test_1_5(a, b, c, *d); end
		def test_2(a, *b); end
		def test_3(*a); end
		def test_4_1(a:, b:); end
		def test_4_2(a:, b:, **c); end
		def test_5_1(a:, **b); end
		def test_5_2(**a); end
		def test_6(a:, b: 1); end
		# Its ok to make required parameters optional
		def test_7(a, b = 1); end

		protected def protected_method(a, b); end

		private def private_method_1(a, b); end
		# Its ok to make visibility less restrictive
		protected def private_method_2(a, b); end
		public def private_method_3(a, b); end
	end
end

def invalid_concrete_class
	Class.new do
		def test_1_1(a); end
		def test_1_2(a, b); end
		def test_1_3; end
		def test_1_4(a, b, c:); end
		def test_1_5(a:, b:, c:); end
		def test_2(a); end
		# It is a violation to add required parameters
		def test_3_1(a); end
		def test_3_2(a, b, c); end
		def test_3_3(a, *d); end
		def test_4_1(a:); end
		def test_4_2(a:, b:, c:); end
		def test_5_1(a:); end
		def test_5_2(a:, b:, **c); end
		def test_6_1(a:); end
		def test_6_2(a:, b:); end
		def test_7_1(a); end
		# It is a violation to change optional params to required
		def test_7_2(a, b); end

		protected def protected_method_1(a); end
		# It is a violation to make visibility more restrictive
		private def protected_method_2(a, b); end

		private def private_method(a); end
	end
end

def test_1_abstract_method = Literal::Method.new(:test_1, abstract_class)
def test_2_abstract_method = Literal::Method.new(:test_2, abstract_class)
def test_3_abstract_method = Literal::Method.new(:test_3, abstract_class)
def test_4_abstract_method = Literal::Method.new(:test_4, abstract_class)
def test_5_abstract_method = Literal::Method.new(:test_5, abstract_class)
def test_6_abstract_method = Literal::Method.new(:test_6, abstract_class)
def test_7_abstract_method = Literal::Method.new(:test_7, abstract_class)

def protected_abstract_method = Literal::Method.new(:protected_method, abstract_class)
def private_abstract_method = Literal::Method.new(:private_method, abstract_class)

describe "#<" do
	test "returns true if the concrete implementation method conforms to the abstract method" do
		assert Literal::Method.new(:test_1_1, valid_concrete_class) < test_1_abstract_method
		assert Literal::Method.new(:test_1_2, valid_concrete_class) < test_1_abstract_method
		assert Literal::Method.new(:test_1_3, valid_concrete_class) < test_1_abstract_method
		assert Literal::Method.new(:test_1_4, valid_concrete_class) < test_1_abstract_method
		assert Literal::Method.new(:test_1_5, valid_concrete_class) < test_1_abstract_method
		assert Literal::Method.new(:test_2, valid_concrete_class) < test_2_abstract_method
		assert Literal::Method.new(:test_3, valid_concrete_class) < test_3_abstract_method
		assert Literal::Method.new(:test_4_1, valid_concrete_class) < test_4_abstract_method
		assert Literal::Method.new(:test_4_2, valid_concrete_class) < test_4_abstract_method
		assert Literal::Method.new(:test_5_1, valid_concrete_class) < test_5_abstract_method
		assert Literal::Method.new(:test_5_2, valid_concrete_class) < test_5_abstract_method
		assert Literal::Method.new(:test_6, valid_concrete_class) < test_6_abstract_method
		assert Literal::Method.new(:test_7, valid_concrete_class) < test_7_abstract_method

		assert Literal::Method.new(:protected_method, valid_concrete_class) < protected_abstract_method
		assert Literal::Method.new(:private_method_1, valid_concrete_class) < private_abstract_method
		assert Literal::Method.new(:private_method_2, valid_concrete_class) < private_abstract_method
		assert Literal::Method.new(:private_method_3, valid_concrete_class) < private_abstract_method
	end

	test "returns false if the concrete implementation method does not conform to the abstract method" do
		refute Literal::Method.new(:test_1_1, invalid_concrete_class) < test_1_abstract_method
		refute Literal::Method.new(:test_1_2, invalid_concrete_class) < test_1_abstract_method
		refute Literal::Method.new(:test_1_3, invalid_concrete_class) < test_1_abstract_method
		refute Literal::Method.new(:test_1_4, invalid_concrete_class) < test_1_abstract_method
		refute Literal::Method.new(:test_1_5, invalid_concrete_class) < test_1_abstract_method
		refute Literal::Method.new(:test_2, invalid_concrete_class) < test_2_abstract_method
		refute Literal::Method.new(:test_3_1, invalid_concrete_class) < test_3_abstract_method
		refute Literal::Method.new(:test_3_2, invalid_concrete_class) < test_3_abstract_method
		refute Literal::Method.new(:test_3_3, invalid_concrete_class) < test_3_abstract_method
		refute Literal::Method.new(:test_4_1, invalid_concrete_class) < test_4_abstract_method
		refute Literal::Method.new(:test_4_2, invalid_concrete_class) < test_4_abstract_method
		refute Literal::Method.new(:test_5_1, invalid_concrete_class) < test_5_abstract_method
		refute Literal::Method.new(:test_5_2, invalid_concrete_class) < test_5_abstract_method
		refute Literal::Method.new(:test_6_1, invalid_concrete_class) < test_6_abstract_method
		refute Literal::Method.new(:test_6_2, invalid_concrete_class) < test_6_abstract_method
		refute Literal::Method.new(:test_7_1, invalid_concrete_class) < test_7_abstract_method
		refute Literal::Method.new(:test_7_2, invalid_concrete_class) < test_7_abstract_method

		refute Literal::Method.new(:protected_method_1, invalid_concrete_class) < protected_abstract_method
		refute Literal::Method.new(:protected_method_2, invalid_concrete_class) < protected_abstract_method
		refute Literal::Method.new(:private_method, invalid_concrete_class) < private_abstract_method
	end
end
