# Literal

This gem is designed to be a simple alternative to Dry Types, Dry Initializer and Dry Struct. It has a lighter weight API that works with `===` and doesn't require defining a global `Types` module. You can use it with plain old Ruby types like `String`, `Integer`, `Proc`, etc. That's fine. If need more power, you can use advanced type matchers like `_Array`, `_Union`, `_Interface`.

## Basic Usage

### Attributes mixin

The attributes mixin allows you to define type safe attribute accessors. By default, writers are private and readers are not defined.

```ruby
class User
  include Literal::Attributes

  attribute :name, String, reader: :public
  attribute :age, Integer, writer: :public
end
```

### Struct

Literal structs are similar to Ruby structs, but they have type safe writers.

```ruby
class Person < Literal::Struct
  attribute :name, String
  attribute :age, Integer
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

### Union

```ruby
_Union(String, Symbol)
```

### Boolean

```ruby
_Boolean
```

### Maybe

```ruby
_Maybe(String)
```

### Array

```ruby
_Array(String)
```

### Set

```ruby
_Set(String)
```

### Enumerable

```ruby
_Enumerable(String)
```

### Tuple
An Enumerable containing exactly the specified types in order.

```ruby
_Tuple(String, Integer)
```

### Hash

```ruby
_Hash(String, Integer)
```

### Interface
```ruby
_Interface(:to_s)
```

### Class

```ruby
_Class(RuntimeError)
```

### Module

```ruby
_Module(Enumerable)
```

### Integer
You can of course just use `Integer` to specify an integer type. The special type `_Integer` allows you to limit that type with a range, while verifying that it's an integer and not something else that matches the range such as a float.

```
_Integer(18..)
```

You can use these types together.
```ruby
_Maybe(Union(String, Symbol, Interface(:to_s), Interface(:to_str), Tuple(String, Symbol)))
```

## Writing your own matchers

Values are compared to types using the types’ `===` operator. So you can define your own special matchers as objects that respond to `===`. It's worth taking a look at how the [built in](https://github.com/joeldrapper/literal/tree/main/lib/literal/types) type matchers are defined.

As it happens, Procs alias `===` to `call`, which means you can provide a proc as a type. The proc will be called with the value and can return `true` or `false`.
