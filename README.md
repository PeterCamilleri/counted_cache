# CountedCache

The counted_cache gem. A cache for use in cases where data is mostly only
read and where the cost of rebuilding that data is high, and yet, the size
of the data is too large to keep all of it in RAM all of the time.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'counted_cache'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install counted_cache

## Usage

Creating a counted cache is as simple as:

```ruby
cache_on_hand = CountedCache.new(10) {|key| retrieve_data_for(key) }
```

Where:

* The argument is the optional cache depth, which is the number of data
items kept in the cache.
* The required block is used to fetch the data associated with the key when
that data is needed, but not currently in the cache.

So how do we use a counted cache to get at our data? That is really simple:

```ruby
data = cache_on_hand[key]
```

That's it! And that is the complete essentials guide. There are a very few
extras to determine how well the cache is working. The hits and misses
properties record how many times the data was found in the cache (a hit) and
how many times it had to be retrieved (a miss).

### Removing data from the cache.

At some point, data items will need to be removed from the cache to make room
for newer data requests.

Normally when this happens, the old data can go away and no further action
needs to be taken. In some cases however, modified data will need to be written
out to save any changes that may have been made to that data. This is done by
giving the cache a block that does the work of saving the data into wherever
is identified by the key.

```ruby
cache_on_hand.set_save_block do |key, data|
  # Code to save data at key goes here.
end
```

### Example

Consider the case of an application that uses embedded ruby (erb) files. This
could look like:

```ruby
erb_cache = CountedCache.new {|name| ERB.new(IO.read(name))}

# Other code omitted.

view_text = erb_cache["home_page/my_file.html.erb"].result(a_binding)
```

The benchmark in the demo folder examines just such a scenario.

## Contributing
1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

OR...

* Make a suggestion by raising an
 [issue](https://github.com/PeterCamilleri/counted_cache/issues)
. All ideas and comments are welcome.

## License

The gem is available as open source under the terms of the
[MIT License](./LICENSE.txt).

## Code of Conduct

Everyone interacting in the counted_cache project’s codebases, issue trackers,
chat rooms and mailing lists is expected to follow the
[code of conduct](./CODE_OF_CONDUCT.md).
