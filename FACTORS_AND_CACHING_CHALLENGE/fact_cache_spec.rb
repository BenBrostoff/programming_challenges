require 'rspec'
require_relative 'fact_cache'

describe '#gen_hash' do 

  context '#factors' do 
    it "should return a hash of keys and values as factors that are also keys" do 
       expect(gen_hash([10, 5, 2, 20], "factors")).to eq({10=>[5, 2], 5=>[], 2=>[], 20=>[10, 5, 2]})
    end
  end

  context '#multiples' do 
    it "should return a hash of keys and values it is a multiple of that are also keys" do
      expect(gen_hash(([10, 5, 2, 20]), "multiples")).to eq({10=>[20], 5=>[10, 20], 2=>[10, 20], 20=>[]})
    end 
  end 

end
