# hash-initializer

Initialise Ruby hashes with multiple levels of default values

## Install

```shell
gem install hash-initializer
```

Or add to your `Gemfile` and go forth.

## Example usage

### With numeric values

```ruby
my_hash = HashInitializer[0]

my_hash[:foo]  # => 0
my_hash[:foo] += 1
my_hash[:foo]  # => 1
my_hash[:bar]  # => 0
```

### With hash values

```ruby
my_hash = HashInitializer[:hash]

my_hash[:foo]  # => {}
my_hash[:foo][:bar]  # => nil
my_hash[:foo][:bar] = 'a'
my_hash[:foo][:bar]  # 'a'
```

### How about array values

```ruby
my_hash = HashInitializer[:array]

my_hash[:foo]  # => []
my_hash[:foo] << 'a'
my_hash[:foo]  # ['a']
```

### Watch out though, you can end up sharing the same array instance (you probably shouldn't do this!)

```ruby
my_hash = HashInitializer[[]]

my_hash[:foo]  # => []
my_hash[:bar]  # => []
my_hash[:foo] << 'a'
my_hash[:foo]  # ['a']
my_hash[:bar]  # ['a']
my_hash[:foo].equal?(my_hash[:bar])  # true
```

### … and you can end up sharing the same hash instance!

```ruby
my_hash = HashInitializer[{}]

my_hash[:foo]  # {}
my_hash[:foo][:bar] = 1
my_hash[:foo][:bar]  # => 1
my_hash[:bob]  # => { bar: 1 }
my_hash[:foo].equal?(my_hash[:bob])  # true
```

### Nested hashes

```ruby
my_hash = HashInitializer[
  :hash,
    :hash,
      1.0
]

my_hash[:foo][:bar][:baz]  # => 1.0
my_hash[:foo][:bar][:baz] += 1.5
my_hash[:foo][:bar][:baz]  # => 2.5
```

## Caution

Use with consideration! Great for temporary data (e.g. whilst processing), or for playing around. But for anything more substantial consider building a proper model layer with first class objects / structs.

## Contributing to hash-initializer

-   Check out the latest master to make sure the feature hasn't been
    implemented or the bug hasn't been fixed yet.
-   Check out the issue tracker to make sure someone already hasn't
    requested it and/or contributed it.
-   Fork the project.
-   Start a feature/bugfix branch.
-   Commit and push until you are happy with your contribution.
-   Make sure to add tests for it. This is important so I don't break it
    in a future version unintentionally.
-   Please try not to mess with the Rakefile, version, or history. If
    you want to have your own version, or is otherwise necessary, that
    is fine, but please isolate to its own commit so I can cherry-pick
    around it.


## Copyright

Copyright (c) 2017 Jits. See
LICENSE.txt for further details.
