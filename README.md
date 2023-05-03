# Literal

## Basic Usage

### Mixin

```ruby
class User
  include Literal::Attributes

  attribute :name, String
  attribute :age, Integer
end
```

### Struct

```ruby
class Person < Literal::Struct
  attribute :name, String
  attribute :age, Integer
end
```

### Data

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
