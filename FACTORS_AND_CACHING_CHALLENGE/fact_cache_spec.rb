require 'rspec'
require 'benchmark'
require_relative 'fact_cache'

describe 'FactCache' do 
  
  let(:test) { FactCache.new }

  context '#factors given integer and array' do
    it "should return an array of factors in the given array" do
      expect(test.factors(10, [2, 5, 30])).to eq([5, 2])
    end
  end

  context '#multiples given integer and array' do
    it "should return an array of integers it is a multiple of in the given array" do
      expect(test.multiples(10, [2, 5, 30])).to eq([30])
    end
  end


  context '#gen_hash given an array and a method' do
    
    let(:perf_a) { Benchmark.measure { test.gen_hash([10, 5, 2, 20], "factors")  }.real }
    let(:perf_b) { Benchmark.measure { test.gen_hash([10, 5, 2, 20], "factors")  }.real }
    let(:perf_c) { Benchmark.measure { test.gen_hash([10, 5, 2, 20], "multiples")  }.real }
    let(:perf_d) { Benchmark.measure { test.gen_hash([10, 5, 2, 20], "multiples")  }.real }

    it "should return a hash of keys and values as factors that are also keys" do 
       expect(test.gen_hash(([10, 5, 2, 20]), "factors")).to eq({10=>[5, 2], 5=>[], 2=>[], 20=>[10, 5, 2]})
    end

    it "should return a hash of keys and values it is a multiple of that are also keys" do
      expect(test.gen_hash(([10, 5, 2, 20]), "multiples")).to eq({10=>[20], 5=>[10, 20], 2=>[10, 20], 20=>[]})
    end 

    it "should display improved performance when results are cached" do
      expect(perf_a > perf_b).to eq(true)
      expect(perf_c >= perf_d).to eq(true)  
    end

  end 
end
