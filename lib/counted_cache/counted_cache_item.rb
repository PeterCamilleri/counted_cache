# A container for items in a counted cache.
class CountedClassItem

  # A marker for empty items.
  EMPTY = :counted_class_item_empty

  # Setup an empty data item.
  def initialize
    @data = EMPTY
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
