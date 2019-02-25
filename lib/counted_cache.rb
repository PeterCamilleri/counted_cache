# The counted_cache class. A cache for use in cases where data is mostly only
# read and where the cost of rebuilding that data is high, and yet, the size
# of the data is too large to keep all of it in RAM all of the time.

require_relative 'counted_cache/object'
require_relative 'counted_cache/counted_cache_item'
require_relative 'counted_cache/version'

class CountedCache

  # How many data elements should be retained.
  attr_reader :depth

  # Setup the cache
  def initialize(depth = 10, &block)
    fail "A data loading block is required" unless block_given?
    @block = block
    @depth = depth
    @key_space  = Hash.new { |hash, key| hash[key] = CountedClassItem.new }
    @data_space = Array.new
  end

  # Get a data item.
  def [](key)
    item = @key_space[key]

    if item.empty?
      item.data = @block.call(key)
    end

    item.data
  end

end
