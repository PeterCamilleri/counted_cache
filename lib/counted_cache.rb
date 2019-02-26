# The counted_cache class. A cache for use in cases where data is mostly only
# read and where the cost of rebuilding that data is high, and yet, the size
# of the data is too large to keep all of it in RAM all of the time.

require_relative 'counted_cache/counted_cache_item'
require_relative 'counted_cache/version'

class CountedCache

  # How many data elements should be retained?
  attr_reader :depth

  # How many times was data found in the cache?
  attr_reader :hits

  # How many times was data not in the cache?
  attr_reader :misses

  # Setup the cache
  def initialize(depth = 10, &load_block)
    fail "A data loading block is required" unless block_given?

    @load_block = load_block
    @save_block = Proc.new {}
    @key_space  = Hash.new {|hash, key| hash[key] = CountedCacheItem.new(key)}
    @data_space = Array.new
    self.depth  = depth
    @hits       = 0
    @misses     = 0
  end

  # Set up the optional block called to save data.
  def set_save_block(&save_block)
    @save_block = save_block
  end

  # Get a data item.
  def [](key)
    item = @key_space[key]

    if item.empty?
      item.data = @load_block.call(key)
      adjust_cache(1)
      @data_space << item
      @misses += 1
    else
      @hits += 1
    end

    item.data
  end

  # Set the new depth.
  def depth=(value)
    value = value.to_i
    fail "The depth must be greater than zero." if value < 1
    @depth = value
    adjust_cache(0)
  end

  # How many cache slots are free?
  def free
    @depth - @data_space.length
  end

private

  # Make sure the data space has at least one free slot.
  def adjust_cache(reserve)
    return if free >= reserve

    @data_space.sort_by!(&:count)

    while free != reserve
      @data_space.shift.purge(@save_block)
    end
  end

end
