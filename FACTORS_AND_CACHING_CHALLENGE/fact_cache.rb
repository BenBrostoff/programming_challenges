require 'benchmark'

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
  factor_hold.find_all { |x| x != num && array.include?(x) }.sort.reverse
end

def multiples(num, array)
  mult_hold = []
  array.each { |x| mult_hold << x if x % num == 0 &&
                   x > num }
  mult_hold 
end

def gen_hash(array, method)
  hash = {}
  array.each do |num|
    m = method(method)
    hash[num] = m.call(num, array)
  end
  hash
end

