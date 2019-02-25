# The counted_cache class. A cache for use in cases where data is mostly only
# read and where the cost of rebuilding that data is high, and yet, the size
# of the data is too large to keep all of it in RAM all of the time.

require_relative 'counted_cache/object'
require_relative 'counted_cache/counted_cache_item'
require_relative 'counted_cache/version'

class CountedCache

  # How many data elements should be retained?
  attr_reader :depth

  # Setup the cache
  def initialize(depth = 10, &block)
    fail "A data loading block is required" unless block_given?

    @block      = block
    @key_space  = Hash.new {|hash, key| hash[key] = CountedClassItem.new(key)}
    @data_space = Array.new
    self.depth  = depth
  end

  # Get a data item.
  def [](key)
    item = @key_space[key]

    if item.empty?
      item.data = @block.call(key)
      adjust_cache
      @data_space << item
    end

    item.data
  end

  # Set the new depth.
  def depth=(value)
    value = value.to_i
    fail "The depth must be greater than zero." if value < 1
    @depth = value
    adjust_cache
  end

private

  # Make sure the data space has at least one free slot.
  def adjust_cache
    if @data_space.length >= @depth
      @data_space.sort_by!(&:count)

      while @data_space.length >= @depth
        @data_space.shift.purge
      end
    end
  end

end
