class Literal::Types::HashType
  def initialize(key_type, value_type)
    @key_type = key_type
    @value_type = value_type
  end

  def inspect
    "Hash(#{@key_type.inspect}, #{@value_type.inspect})"
  end

  def ===(value)
    value.is_a?(::Hash) && value.all? { |key, value| @key_type === key && @value_type === value }
  end
end
