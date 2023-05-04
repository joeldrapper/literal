# Literal

This gem is designed to be a simple alternative to Dry Types, Dry Initializer and Dry Struct. It has a lighter API that works with `===` and doesn’t require defining a global `Types` module. You can use it with plain old Ruby types like `String`, `Integer`, `Proc`, etc. If need more power, you can use advanced type matchers like `_Array`, `_Union`, `_Interface`.

### What's the point?

While I’m excited about advances in RBS and Steep, I think we've still got a long way to go before they can be used in many applications. In the meantime, I think you can get a long way by adding lightweight type checking to public interfaces for specific classes on initializers and attribute writers. Literal is designed to help define and enforce this.

### What about performance?

Some of the advanced types, such as `_Array` and `_Hash` could be pretty bad for performance. The idea here is the disable these type checks in production, though I haven't built the switch for that just yet.

## Basic Usage

### Attributes mixin

The attributes mixin allows you to define type-checked attribute accessors. By default, writers are private and readers are not defined.

You can specify that you want `:public` or `:private` readers. You can also specify that you want writers to be `:public`.

```ruby
class User
  include Literal::Attributes

  attribute :name, String, reader: :public
  attribute :age, 18.., writer: :public
end
```

The attributes mixin also defines a default `initializer`, which assigns keyword arguments via the type-checked writers.

### Struct

Literal structs are similar to Ruby structs, but they have type-checked writers.

```ruby
class Person < Literal::Struct
  attribute :name, _Maybe(String)
  attribute :age, _Union(Integer, Float)
end
```

### Data

Literal data is essentially a deep frozen struct.

```ruby
class Person < Literal::Data
  attribute :name, String
  attribute :age, Integer
end
```

## Special Types

The following types are designed to work like generics in other languages. In Ruby, they are implemented as methods that return an object with an `===` method to match the given value.

#### `_Union`

A union type means one of the other. For example, if you want to accept a `String` or a `Symbol`, you could make a union.

```ruby
_Union(String, Symbol)
```

### `_Any`
`_Any` is a union of all types apart from `nil`. It's not literally implemented like that, but that's how you can think about it. You could include nil with `_Maybe`

```ruby
_Maybe(_Any)
```

#### `_Boolean`

`_Boolean` is a union of `true` and `false`. It’s literally `_Union(true, false)`.

```ruby
_Boolean
```

#### `_Maybe`

`_Maybe` is union of whatever type you give it and `nil`. This is how you make optional arguments.

```ruby
_Maybe(String)
```

### `_Array`

The `_Array` type takes a specific type for the items of the array. It will match only if all items in the array match that type.

```ruby
_Array(String)
```

### `_Set`

Like `_Array` but for `Set`s.

```ruby
_Set(String)
```

### `_Enumerable`

Like `_Array`, but for any `Enumerable`.

```ruby
_Enumerable(String)
```

### `_Tuple`
An Enumerable containing exactly the specified types in order. For example, if you expect an Array of exactly two items where the first is a `String` and the second is an `Integer`, you could specify that as a `_Tuple` type.

```ruby
_Tuple(String, Integer)
```

### `_Hash`

A `Hash` type that ensures all the keys and values match the provided types.

```ruby
_Hash(String, Integer)
```

### `_Interface`
The `_Interface` type ensures the given value responds to the methods defined on the interface. Note: there's currently no way to match the arity of the methods. If you have any ideas about how to do this, please open an issue.

```ruby
_Interface(:to_s)
```

### `_Class`

Match a `Class` that's either the given class or a subclass of the given class.

```ruby
_Class(RuntimeError)
```

### `_Integer`
You can of course just use `Integer` to specify an integer type. The special type `_Integer` allows you to limit that type with a range, while verifying that it's an `Integer` and not something else that matches the range such as a `Float`.

```
_Integer(18..)
```

### `_Float`

Same as integer, but for `Float`s.

```ruby
_Float(1.4..6.4)
```

You can compose these types together.

```ruby
_Maybe(Union(String, Symbol, Interface(:to_s), Interface(:to_str), Tuple(String, Symbol)))
```

## Writing your own matchers

Values are compared to types using the types’ `===` operator. So you can define your own special matchers as objects that respond to `===`. It's worth taking a look at how the [built in](https://github.com/joeldrapper/literal/tree/main/lib/literal/types) type matchers are defined.

As it happens, Procs alias `===` to `call`, which means you can provide a proc as a type. The proc will be called with the value and can return `true` or `false`.
