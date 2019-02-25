require_relative '../lib/counted_cache'
require          'minitest/autorun'
require          'minitest_visible'

class CountedCacheTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil(::CountedCache::VERSION)
    assert(::CountedCache::VERSION.frozen?)
    assert(::CountedCache::VERSION.is_a?(String))
    assert(/\A\d+\.\d+\.\d+/ =~ ::CountedCache::VERSION)
  end

  def test_that_it_has_a_description
    refute_nil(::CountedCache::DESCRIPTION)
    assert(::CountedCache::DESCRIPTION.frozen?)
    assert(::CountedCache::DESCRIPTION.is_a?(String))
  end

  def test_creating_these_caches
    assert_raises { ::CountedCache.new }
    assert_raises { ::CountedCache.new("foobar") {|key| key }}

    a_cache = CountedCache.new {|key| key}
    assert_equal(10, a_cache.depth)
    assert_equal(0, a_cache.hits)
    assert_equal(0, a_cache.misses)

    a_cache = CountedCache.new(20) { |key| key }
    assert_equal(20, a_cache.depth)

    assert_equal("foo", a_cache["foo"])
    assert_equal(a_cache["foo"].object_id, a_cache["foo"].object_id)
  end

  def test_creating_items
    an_item = CountedClassItem.new("foo")
    assert(an_item.empty?)
    assert_equal(0, an_item.count)
    an_item.data = "foo"
    refute(an_item.empty?)
    assert_equal("foo", an_item.data)
    assert_equal(1, an_item.count)
    an_item.purge
    assert(an_item.empty?)
  end

  def test_for_the_support_protocol
    assert_nil(Object.new.counted_cache_item_removed(:key))
  end

  def test_for_caching
    a_cache = CountedCache.new(2) { |key| key }
    assert_equal(2, a_cache.free)
    assert_equal(0, a_cache.hits)
    assert_equal(0, a_cache.misses)

    assert_equal("a", a_cache["a"])
    assert_equal(1, a_cache.free)
    assert_equal(0, a_cache.hits)
    assert_equal(1, a_cache.misses)

    assert_equal("a", a_cache["a"])
    assert_equal(1, a_cache.free)
    assert_equal(1, a_cache.hits)
    assert_equal(1, a_cache.misses)

    assert_equal("b", a_cache["b"])
    assert_equal(0, a_cache.free)
    assert_equal(1, a_cache.hits)
    assert_equal(2, a_cache.misses)

    assert_equal("a", a_cache["a"])
    assert_equal(0, a_cache.free)
    assert_equal(2, a_cache.hits)
    assert_equal(2, a_cache.misses)

    assert_equal("a", a_cache["a"])
    assert_equal(0, a_cache.free)
    assert_equal(3, a_cache.hits)
    assert_equal(2, a_cache.misses)

    assert_equal("c", a_cache["c"])
    assert_equal(0, a_cache.free)
    assert_equal(3, a_cache.hits)
    assert_equal(3, a_cache.misses)

    assert_equal("a", a_cache["a"])
    assert_equal(0, a_cache.free)
    assert_equal(4, a_cache.hits)
    assert_equal(3, a_cache.misses)

    assert_equal("b", a_cache["b"])
    assert_equal(0, a_cache.free)
    assert_equal(4, a_cache.hits)
    assert_equal(4, a_cache.misses)

    assert_equal("c", a_cache["c"])
    assert_equal(0, a_cache.free)
    assert_equal(4, a_cache.hits)
    assert_equal(5, a_cache.misses)
  end

end
