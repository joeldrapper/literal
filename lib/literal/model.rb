class Literal::Model
  extend Literal::Types
  include Literal::Initializer

  def self.__attributes__
    return @required_attributes if defined?(@required_attributes)
    @required_attributes = superclass.is_a?(self) ? superclass.required_attributes.dup : []
  end

  def self.attribute(name, type)
    __attributes__ << name

    writer_name = :"#{name}="

    define_method writer_name do |value|
      raise Literal::TypeError, "Expected #{name}: `#{value.inspect}` to be: `#{type.inspect}`." unless type === value
      super(value)
    end

    name
  end
end
