# ActiverecordLazyColumns

`activerecord_lazy_columns` is a gem that lets you specify columns to be loaded lazily in your Active Record models.

By default, Active Record loads all the columns in each model instance. This gem lets you specify columns
to be excluded by default. This is useful to reduce the memory taken by Active Record when loading records
that have large columns if those particular columns are actually not required most of the time.
In this situation it can also greatly reduce the database query time because loading large BLOB/TEXT columns
generally means seeking other database pages since they are not stored wholly in the record's page itself.

Notice that a better approach can be moving those columns to new models, since Active Record loads related models
lazily by default. This gem is an easy workaround.

## Requirements

- ruby 3.2+
- activerecord 7.2+

## Installation

Add this line to your application's Gemfile:

```ruby
gem "activerecord_lazy_columns"
```

## Usage

Use `lazy_columns` in your Active Record models to define which columns should be loaded lazily:

```ruby
class Action < ApplicationRecord
  lazy_columns :comments
end
```

Now, when you fetch some action, the comments are not loaded:

```ruby
Action.create!(title: "Some action", comments: "Some comments") # => <Action id: 1...>
action = Action.find(1) # => <Action id: 1, title: "Some action">
```

And if you try to read the `comments` attribute, it will be loaded into the model:

```ruby
action.comments # => "Some comments"
action # => <Action id: 1, title: "Some action", comments: "Some comments"
```

## How the gem works

This gem does two things:

- Modifies the `default_scope` of the model so that it fetches all the attributes except the ones marked as lazy.
- Defines a reader method per lazy attribute that will load the corresponding column under demand.

### Eager loading of attributes defined as lazy

The first time you access a lazy attribute, a new database query will be executed to load it. If you are going
to operate on a number of objects and want to have the lazy attributes eagerly loaded, use Active Record's
`.select()` in the initial query. For example:

```ruby
Action.select(:comments)
```

## Credits

Thanks to the [`lazy_columns` gem](https://github.com/jorgemanrubia/lazy_columns) for the original idea.

## Development

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update
the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag
for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/fatkodima/activerecord_lazy_columns.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
