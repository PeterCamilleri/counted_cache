# A container for items in a counted cache.
class CountedClassItem

  # A marker for empty items.
  EMPTY = :counted_class_item_empty

  # The reference count of this item.
  attr_reader :count

  # Let the data be set.
  attr_writer :data

  # Setup an empty data item.
  def initialize(key)
    @data  = EMPTY
    @key   = key
    @count = 0
  end

  # Is this item empty?
  def empty?
    @data == EMPTY
  end

  # Erase the data associated with the given key.
  def purge
    @data.counted_cache_item_removed(@key)
    @data = EMPTY
  end

  # Retrieve the data, maintain a reference count.
  def data
    @count += 1
    @data
  end
end
