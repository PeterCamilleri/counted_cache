# Patches to the Object class to support the counted cache.
class Object

  # An item has been removed from a counted cache.
  # By default, do nothing.
  def count_cache_item_removed(_key)
  end

end
