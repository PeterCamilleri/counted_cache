# A benchmark showing the effectiveness of the counted cache.

require "benchmark/ips"
require 'erb'
require_relative '../lib/counted_cache'

x = 42
$env  = binding

file_names = ["docs/erb/a.erb", "docs/erb/b.erb", "docs/erb/c.erb", "docs/erb/d.erb",
              "docs/erb/e.erb", "docs/erb/f.erb", "docs/erb/g.erb", "docs/erb/h.erb",
              "docs/erb/i.erb", "docs/erb/j.erb", "docs/erb/k.erb", "docs/erb/l.erb",
              "docs/erb/m.erb", "docs/erb/n.erb", "docs/erb/o.erb", "docs/erb/p.erb"]

file_counts = [200, 100, 50, 25, 12, 6, 3, 2, 1, 1, 1, 1, 1, 1, 1, 1]
$work = []
file_names.each_with_index {|name, index| $work.concat(Array.new(file_counts[index], name)) }
$work.shuffle!

$cache = CountedCache.new(5) {|name| ERB.new(IO.read(name))}

def no_cache
  $work.each do |name|
    view = ERB.new(IO.read(name)).result($env)
  end
end

def with_cache
  $work.each do |name|
    view = $cache[name].result($env)
  end
end

Benchmark.ips do |x|

  x.report("no_cache") { no_cache }
  x.report("with_cache") { with_cache }

  x.compare!
end
