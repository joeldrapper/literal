# A Literal Ruby Gem [WIP]

## Types

Literal uses Ruby-native types. Any method that responds to `===(value)` is considered a type. Note, this is how Ruby’s case statements and pattern matching work. It’s also how `Array#any?` and `Array#all?` work. Essentially all Ruby objects are types and just work the way you’d expect them to. A few examples:

- On a `Range`, `===(value)` checks if the value is within the range.
- On a `Regexp`, `===(value)` checks if the value matches the pattern.
- On a `Class`, `===(value)` checks if the value is an instance of the class.
- On a `Proc`, `===(value)` calls the proc with the value.
- On a `String`, `===(value)` checks if the value is equal to the string.
- On the class `String`, `===(value)` checks if the value is a string.

Literal extends this idea with the concept of generics or _parameterised_ types. A generic is a method that returns an object that respond to `===(value)`.

If we want to check that a given value is an `Array`, we could do this:

```ruby
Array === [1, 2, 3]
```

But what if we want to check that it’s an Array of Integers? Literal provides a library of special types that can be composed for this purpose. In this case, we can use the type `_Array(Integer)`.

```ruby
_Array(Integer) === [1, 2, 3]
```

These special types are defined on the `Literal::Types` module. To access them in a class, you can `extend` this module. To access them on an instance, you can `include` the module. If you want to use them globally, you can `extend` the module at the root.

```ruby
extend Literal::Types
```

This is recommended for applications, but not for libraries, as we don’t want to pollute the global namespace from library code.

`Literal::Properties`, `Literal::Object`, `Literal::Struct` and `Literal::Data` already extend `Literal::Types`, so you don’t need to extend `Literal::Types` yourself if you’re only using literal types for literal properties.

## Properties

`Literal::Properties` is a mixin that allows you to define the structure of an object. Properties are defined using the `prop` method.

The first argument is the name of the property as a `Symbol`. The second argument is the _type_ of the property. Remember, the type can be any object that responds to `===(value)`.

The third argument is optional. You can set this to `:*`, `:**`, `:&`, or `:positional` to change the kind of initializer parameter.

```ruby
class Person
  extend Literal::Properties

  prop :name, String
  prop :age, Integer
end
```

You can also use keyword arguments to define _readers_ and _writers_. These can be set to `false`, `:public`, `:protected`, or `:private` and default to `false`.

```ruby
class Person
  extend Literal::Properties

  prop :name, String, reader: :public
  prop :age, Integer, writer: :protected
end
```

Properties are required by deafult. To make them optional, set the type to a that responds to `===(nil)` with `true`. `Literal::Types` provides a special types for this purpose. Let’s make the age optional by setting its type to a `_Nilable(Integer)`:

```ruby
class Person
  extend Literal::Properties

  prop :name, String
  prop :age, _Nilable(Integer)
end
```

Alternatively, you can give the property a default value. This default value must match the type of the property.

```ruby
class Person
  extend Literal::Properties

  prop :name, String, default: "John Doe"
  prop :age, _Nilable(Integer)
end
```

Note, the above example will fail unless you have frozen string literals enabled. (Which, honestly, you should.) Default values must be frozen. If you can’t use a frozen value, you can pass a proc instead.

```ruby
class Person
  extend Literal::Properties

  prop :name, String, default: -> { "John Doe" }
  prop :age, _Nilable(Integer)
end
```

The proc will be called to generate the default value.

You can also pass a block to the `prop` method. This block will be called with the value of the property when it’s set, which is useful for coercion.

```ruby
class Person
  extend Literal::Properties

  prop :name, String
  prop :age, Integer do |value|
    value.to_i
  end
end
```

Coercion takes place prior to type-checking, so you can safely coerce a value to a different type in the block.

You can use properties that conflict with ruby keywords. Literal will handle everything for you automatically.

```ruby
class Person
  extend Literal::Properties

  prop :class, String, :positional
  prop :end, Integer
end
```

If you’d prefer to subclass than extend a module, you can use the `Literal::Object` class instead. `Literal::Object` literally extends `Literal::Properties`.

```ruby
class Person < Literal::Object
  prop :name, String
  prop :age, Integer
end
```

## Structs

`Literal::Struct` is like `Literal::Object`, but it also provides a few extras.

Structs implement `==` so you can compare one struct to another. They also implement `hash`. Structs also have public _readers_ and _writers_ by default.

```ruby
class Person < Literal::Struct
  prop :name, String
  prop :age, Integer
end
```

## Data

`Literal::Data` is like `Literal::Struct`, but you can’t define _writers_. Additionally, objects are _frozen_ after initialization. Additionally any non-frozen properties are duplicated and frozen.

```ruby
class Person < Literal::Data
  prop :name, String
  prop :age, Integer
end
```
