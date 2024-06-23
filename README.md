# A Literal Ruby Gem [WIP]

## Types

Literal uses Ruby-native types. Any method that responds to `===(value)` is considered a type. Note, this is how Ruby’s case statements and pattern matching work. It’s also how `Array#any?` and `Array#all?` work. Essentially all Ruby objects are types and just work the way you’d expect them to. A few examples:

- On a `Range`, `===(value)` checks if the value is within the range.
- On a `Regexp`, `===(value)` checks if the value matches the pattern.
- On a `Class`, `===(value)` checks if the value is an instance of the class.
- On a `Proc`, `===(value)` calls the `Proc` with the value.
- On a `String`, `===(value)` checks if the value is equal to the string.
- On the class `String`, `===(value)` checks if the value is a string.

Literal extends this idea with the concept of generics or _parameterised_ types. A generic is a method that returns an object that respond to `===(value)`.

If we want to check that a given value is an `Array`, we could do this:

```ruby
Array === [1, 2, 3]
```

But what if we want to check that it’s an Array of Integers? Literal provides a library of special types taht can be composed for this purpose. In this case, we can use the type `_Array`.

```ruby
_Array(Integer) === [1, 2, 3]
```

These special types are defined on the `Literal::Types` module. To access them in a class, you can `extend` this module. To access them on an instance, you can `include` the module. If you want to use them globally, you can `extend` the module at the root.

```ruby
extend Literal::Types
```

This is recommended for applications, but not for libraries, as we don’t want to pollute the global namespace from library code.

`Literal::Properties`, `Literal::Object`, `Literal::Struct` and `Literal::Data` already extend `Literal::Types`, so you don’t need to extend `Literal::Types` yourself if you’re only using literal types for literal properties.
