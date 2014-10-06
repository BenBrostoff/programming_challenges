require 'benchmark'

class FactCache
  attr_reader :cache

  def initialize 
    @cache = {}
  end

  def check_cache(array)
     @cache[array] ? @cache[array] : false
  end

  def factors(num, array)
    factor_hold = []
    n = 1
    while n <= num ** 0.5
      if num % n == 0
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
    mult_hold
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


