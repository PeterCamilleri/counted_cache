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

    a_cache = CountedCache.new { |_cache, key| key }
    assert_equal(10, a_cache.depth)
  end

  def test_for_the_support_protocol
    assert_nil(Object.new.counted_cache_item_removed(:key))
  end

end
