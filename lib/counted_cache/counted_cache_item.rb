# A container for items in a counted cache.
class CountedClassItem

  # A marker for empty items.
  EMPTY = :counted_class_item_empty

  # The reference count of this item.
  attr_reader :count

  # Setup an empty data item.
  def initialize
    @data = EMPTY
    @count = 0
  end

  # Is this item empty?
  def empty?
    @data == EMPTY
  end

  def purge(key)
    @data.counted_cache_item_removed(key)
    @data = EMPTY
  end
end
