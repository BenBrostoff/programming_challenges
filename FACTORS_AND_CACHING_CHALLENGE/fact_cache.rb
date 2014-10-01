require 'benchmark'

class FactCache

  attr_reader :cache

  def initialize 
    @cache = {}
  end

  def check_cache(array)
    return @cache[array] if @cache[array]
    return false 
  end

  def factors(num, array)
    factor_hold = []
    n = 1
    while n <= num ** 0.5
      if num.modulo(n) == 0
        factor_hold << n
        factor_hold << num / n unless num / n == n
      end
      n += 1
    end
    final = factor_hold.find_all { |x| x != num && array.include?(x) }.sort.reverse
  end

  def multiples(num, array)
    mult_hold = []
    array.each { |x| mult_hold << x if x % num == 0 &&
                     x > num }
  end

  def gen_hash(array, method)
    return check_cache(array) if check_cache(array) != false
    hash = {}
    array.each do |num|
      m = method(method)
      hash[num] = m.call(num, array)
    end
    @cache[array] = hash
    hash
  end

end

test = FactCache.new
p "A ***"
puts Benchmark.measure { test.gen_hash([10, 5, 2, 20], "factors") }
p "B ***"
puts Benchmark.measure { test.gen_hash([10, 5, 2, 20], "factors") }




