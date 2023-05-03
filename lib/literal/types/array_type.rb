class Literal::Types::ArrayType
  def initialize(type)
    @type = type
  end

  def inspect
    "Array(#{@type.inspect})"
  end

  def ===(value)
    value.is_a?(::Array) && value.all? { |item| @type === item }
  end
end
